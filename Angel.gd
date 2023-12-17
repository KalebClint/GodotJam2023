extends CharacterBody3D

@onready var navAgent = $NavigationAgent3D


@onready var animation_tree = $AnimationTree

@onready var manager

@onready var player = $"../../../../../Player"

var firstPoint
var secondPoint
var thirdPoint

var speed = 7

var pointOne = true
var pointTwo = false
var pointThree = false

var idle = false
var walking = false
var chasing = false

var attacking = false

func _ready():
	manager = get_node("/root/GameManager")
	print(manager)
	await get_tree().create_timer(1).timeout
	var rand = randi_range(1,2)
	if rand == 1:
		becomeIdle()
	elif rand == 2:
		idle = false
		walking = true
		walkToNextPoint()
	
func _physics_process(delta):
	var currentLocation = global_transform.origin
	var next_location = navAgent.get_next_path_position()
	var newVelocity = (next_location - currentLocation).normalized() * speed
	
	navAgent.set_velocity(newVelocity)
	
	var d = position.x - player.position.x
	
	if d < 20:
		chasing = true
		updateTargetLocation(player.global_transform.origin)
	
	if chasing:
		speed = 11
	else:
		speed = 7
		
	if !chasing:
		if global_transform.origin.is_equal_approx(next_location):
			return
		look_at(next_location)
	else:
		walking = false
		idle = false
		look_at(player.global_transform.origin)
	
	rotation.x = 0
	
	$AnimationTree.set("parameters/conditions/walk", walking)
	$AnimationTree.set("parameters/conditions/idle", idle)
	$AnimationTree.set("parameters/conditions/run", chasing)
	$AnimationTree.set("parameters/conditions/attacking", attacking)
	
func updateTargetLocation(targetLoc):
	if targetLoc != null:
		navAgent.target_position = targetLoc
	else:
		print("Target Non Existant")
	
func setPoints(PointOne,PointTwo,PointThree):
	pointOne = PointOne
	secondPoint = PointTwo
	thirdPoint = PointThree
	
func walkToNextPoint():
	if !chasing:
		var rand = randi_range(1,2)
		if rand == 1:
			if pointOne:
				updateTargetLocation(secondPoint)
				pointOne = false
				pointTwo = true
			elif pointTwo:
				updateTargetLocation(thirdPoint)
				pointTwo = false
				pointThree = true
			elif pointThree:
				updateTargetLocation(firstPoint)
				pointThree = false
				pointOne = true
		walking = true
		idle = false
	
func _on_navigation_agent_3d_target_reached():
	if !idle && !chasing:
		becomeIdle()
	elif chasing && !attacking:
		attackPlayer()
	
func becomeIdle():
	idle = true
	walking = false
	await get_tree().create_timer(randi_range(5,15)).timeout
	walkToNextPoint()

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if !idle && !attacking:
		velocity = velocity.move_toward(safe_velocity,0.25)
		move_and_slide()
		walking = true

func attackPlayer():
	attacking = true
	player.stunned()
	await get_tree().create_timer(3).timeout
	attacking = false
	chasing = true
	






extends CharacterBody3D

@onready var navAgent = $NavigationAgent3D

@onready var animation_tree = $AnimationTree

@onready var manager

@onready var player = $"../../../../../../Player"

var firstPoint
var secondPoint
var thirdPoint

var speed = 3

var pointOne = true
var pointTwo = false
var pointThree = false

var idle = false
var dead = false
var running = false
var walking = false

var shocked = false
var lookAtThat

var runToPos

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
	
func _physics_process(_delta):
	var currentLocation = global_transform.origin
	var next_location = navAgent.get_next_path_position()
	var newVelocity = (next_location - currentLocation).normalized() * speed
	
	navAgent.set_velocity(newVelocity)
	
	
	if running:
		speed = 5
	else:
		speed = 3
		
		
	if running:
		look_at(runToPos)
	elif shocked:
		look_at(lookAtThat)
	elif !shocked:
		if global_transform.origin.is_equal_approx(next_location):
			return
		look_at(next_location)

	
	rotation.x = 0
	
	$AnimationTree.set("parameters/conditions/walking", walking)
	$AnimationTree.set("parameters/conditions/shook", shocked)
	$AnimationTree.set("parameters/conditions/idle", idle)
	$AnimationTree.set("parameters/conditions/died", dead)
	
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
	elif rand == 2:
		if pointOne:
			updateTargetLocation(thirdPoint)
			pointOne = false
			pointThree = true
		elif pointTwo:
			updateTargetLocation(firstPoint)
			pointTwo = false
			pointOne = true
		elif pointThree:
			updateTargetLocation(secondPoint)
			pointThree = false
			pointTwo = true
	walking = true
	idle = false
	
func _on_navigation_agent_3d_target_reached():
	if !idle:
		becomeIdle()
	
func becomeIdle():
	if !dead:
		idle = true
		walking = false
		running = false
		await get_tree().create_timer(randi_range(5,15)).timeout
		walkToNextPoint()

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if !dead && ! shocked && !idle:
		velocity = velocity.move_toward(safe_velocity,0.25)
		move_and_slide()
		walking = true

func deathHappened(dedNPC):
	var d = position.z - dedNPC.position.z
	if d < 5:
		print("seen death")
		lookAtThat = dedNPC.position
		walking = false
		idle = false
		shocked = true
		await get_tree().create_timer(2).timeout
		shocked = false
		runningAway()
	
func died():
	manager.aNpcDied(get_node(get_path()))
	dead = true
	idle = false
	walking = false
	running = false
	shocked = false
	await get_tree().create_timer(5).timeout
	queue_free()

func runningAway():
	running = true
	
	runToPos = player.position
	
	runToPos.z += 50
	runToPos.x += randf_range(6,-6)
	
	updateTargetLocation(runToPos)






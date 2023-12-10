extends CharacterBody3D

@onready var navAgent = $NavigationAgent3D

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


func _ready():
	pointOne = true
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
	

	
func updateTargetLocation(targetLoc):
	if targetLoc != null:
		navAgent.target_position = targetLoc
	
func setPoints(PointTwo,PointThree):
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
			updateTargetLocation(position)
			pointThree = false
			pointOne = true
	else: #If Rand is 2
		if pointOne:
			updateTargetLocation(thirdPoint)
			pointOne = false
			pointThree = true
		elif pointTwo:
			updateTargetLocation(position)
			pointTwo = false
			pointOne = true
		elif pointThree:
			updateTargetLocation(secondPoint)
			pointThree = false
			pointTwo = true
	
func _on_navigation_agent_3d_target_reached():
	if !idle:
		becomeIdle()
	
func becomeIdle():
	idle = true
	walking = false
	running = false
	await get_tree().create_timer(randi_range(10,30)).timeout
	walkToNextPoint()


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity,0.25)
	move_and_slide()

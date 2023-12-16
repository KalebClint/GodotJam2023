extends CharacterBody3D

@onready var characterMesh = $VampireMesh

@onready var theTree = $AnimationTree

@onready var GameManager = $".."

@onready var sun = $"../SUNSTUFF/Sun"

@onready var illBarUI = $PlayerUI/illBar

@onready var audio = $Audio

var underShade = false
var sunAbove = false

var illBar = 0

var Health = 20

var maxStanima = 15
var stanima = 15

var sprinting = true
var tired = false

var SPEED = 7.5
const JUMP_VELOCITY = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass


func _physics_process(delta):
	
	if Input.is_action_pressed("shift") && stanima > 0 && !tired:
		sprinting = true
	else:
		sprinting = false
		
	if !sprinting:
		SPEED = 12
		
	if Input.is_action_just_released("shift"):
		sprinting = false
		
	if sprinting == true:
		SPEED = 16
		stanima -= 0.03
		
		if stanima <= 0:
			tired = true
			sprinting = false
			
	else:
		if stanima < 10:
			stanima += 0.03
			
	if stanima >= 10:
		tired = false
			
	if !underShade && sunAbove:
		#illBar += 0.13
		if illBar >= 100:
			#Kill The Player
			illBar = 0
			position.x = 1
			position.y = 0
			position.z = 7
				
			#print(illBar)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("a_key", "d_key", "w_key", "s_key")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		characterMesh.look_at(position - direction)
		characterMesh.rotation.x = 0
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if input_dir == Vector2.ZERO && is_on_floor():
		sprinting = false

	$AnimationTree.set("parameters/conditions/idle", input_dir == Vector2.ZERO && is_on_floor())
	$AnimationTree.set("parameters/conditions/walk", !sprinting && input_dir != Vector2.ZERO && is_on_floor())
	$AnimationTree.set("parameters/conditions/run", sprinting && is_on_floor())
	$AnimationTree.set("parameters/conditions/jump", !is_on_floor())
	
	
	if input_dir != Vector2.ZERO:
		if !audio.playing:
			audio.play()
	
	var pos = global_transform.origin
	var sunPos = sun.global_transform.origin

	# Calculate the distance along the Z-axis
	var distance = pos.z - sunPos.z

	# Check if the distance is greater than the maximum allowed distance
	illBar = 100 - distance

	# Ensure the result is clamped between 0 and 100
	illBar = clamp(illBar, 0, 100)
	
	illBarUI.value = illBar
	
	if illBar >= 90:
		playerDies()
	
	
	move_and_slide()

func _on_sun_collider_body_entered(body):
	if body.name == "Player":
		sunAbove = true

func _on_sun_collider_body_exited(body):
	if body.name == "Player":
		sunAbove = false

func healPlayer():
	Health += 20

func playerDies():
	get_tree().reload_current_scene()

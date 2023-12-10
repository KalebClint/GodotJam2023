extends CharacterBody3D

@onready var characterMesh = $Mesh
@onready var GameManager = $".."



var underShade = false
var sunAbove = false

var illBar = 0

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _physics_process(delta):
	
	#If it is daytime, check if the player is under shade. If not increase Ill bar
	if GameManager.daytime:
		if !underShade && sunAbove:
			illBar += 0.13
			if illBar >= 100:
				#Kill The Player
				illBar = 0
				position.x = 1
				position.y = 0
				position.z = 7
				
			print(illBar)

	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("a_key", "d_key", "w_key", "s_key")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		characterMesh.look_at(position + direction)
		characterMesh.rotation.x = 0
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_sun_collider_body_entered(body):
	if body.name == "Player":
		sunAbove = true

func _on_sun_collider_body_exited(body):
	if body.name == "Player":
		sunAbove = false
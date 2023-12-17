extends CharacterBody3D

@onready var characterMesh = $VampireMesh

@onready var theTree = $AnimationTree

@onready var GameManager = $".."
@onready var playerUI = $PlayerUI

@onready var sun = $"../SUNSTUFF/Sun"

@onready var illBarUI = $PlayerUI/illBar
@onready var hungerBarUI = $PlayerUI/hungerBar
@onready var scoreLabel = $PlayerUI/Label

@onready var audio = $Audio
@onready var casta = $VampireMesh/Casta

@onready var pauseMenu = $PlayerUI/Pause
@onready var stanimaBar = $PlayerUI/StanimaBar

var score = 0

var pauseHunger = false
var attacking = false

var underShade = false
var sunAbove = false

var illBar = 0
var hunger = 100
var hungLossSpeed = 0.035

var maxStanima = 15
var stanima = 15

var playerStunned = false

var sprinting = true
var tired = false

var zLevel
var theZLevel
var furthestZ

var SPEED = 7.5
const JUMP_VELOCITY = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	furthestZ = 0
	zLevel = position.z
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hunger = 100
	score = 0

func _physics_process(delta):
	
	if sprinting == true || stanima < 15:
		stanimaBar.show()
	else:
		stanimaBar.hide()
	
	stanimaBar.value = stanima
	
	
	
	zLevel = position.z
	
	if zLevel > furthestZ:
		if zLevel > furthestZ:
			score += 1
			furthestZ = zLevel
	
	theZLevel = zLevel
	scoreLabel.text = "Score: " + str(score)
	
	if !pauseHunger:
		hunger -= hungLossSpeed
	hunger = clamp(hunger, 0,100)
	
	if hunger <= 1:
		playerDies()
	
	hungerBarUI.value = hunger
	
	if Input.is_action_pressed("pauseButton"):
		pauseMenu.show()
		get_tree().paused = true
	
	if Input.is_action_pressed("shift") && stanima > 0 && !tired:
		sprinting = true
	else:
		sprinting = false
		
	if !sprinting:
		SPEED = 12
		
	if Input.is_action_just_released("shift"):
		sprinting = false
		
	if Input.is_action_just_pressed("bloodSuck") && !attacking:
		bloodSuck()
		
	if sprinting == true:
		SPEED = 16
		stanima -= 0.03
		
		if stanima <= 0:
			tired = true
			sprinting = false
			
	else:
		if stanima < 15.03:
			stanima += 0.03
			
	if stanima >= 10:
		tired = false
			
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
		if !attacking && !playerStunned:
			characterMesh.look_at(position - direction)
		characterMesh.rotation.x = 0
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if input_dir == Vector2.ZERO && is_on_floor():
		sprinting = false

	$AnimationTree.set("parameters/conditions/idle", input_dir == Vector2.ZERO && is_on_floor() && !attacking && !playerStunned)
	$AnimationTree.set("parameters/conditions/walk", !sprinting && input_dir != Vector2.ZERO && is_on_floor() && !attacking && !playerStunned)
	$AnimationTree.set("parameters/conditions/run", sprinting && is_on_floor() && !attacking && !playerStunned)
	$AnimationTree.set("parameters/conditions/jump", !is_on_floor() && !attacking && !playerStunned)
	$AnimationTree.set("parameters/conditions/attack", attacking && !playerStunned)
	
	
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
	
	if !attacking && !playerStunned:
		move_and_slide()

func bloodSuck():
	attacking = true
	
	var isNpc = false
	if casta.is_colliding():
		var col = casta.get_collider()
		if col.is_in_group("NPC"):
			isNpc = true
			var col_ = col.get_node(col.get_path())
			col_.died()
			
	await get_tree().create_timer(1.5).timeout
	
	if isNpc:
		playerDrinks()
	
	attacking = false

func stunned():
	playerStunned = true
	await get_tree().create_timer(2).timeout
	playerStunned = false

func playerDrinks():
	hunger += 25
	pauseTheHunger()

func playerDies():
	playerUI.playerDied(score)

func pauseTheHunger():
	pauseHunger = true
	await get_tree().create_timer(4).timeout
	pauseHunger = false

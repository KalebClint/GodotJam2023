extends CharacterBody3D

@onready var player = $"../Player"

@onready var bat_point = $"../Player/BatPoint"

@onready var navAgent = $NavigationAgent3D

@onready var bat = $Bat

@onready var NpcTarget

var carryingBlood = false
var chasing = false
var attacking = false


var withPlayer = false

var speed = 5

func _physics_process(delta):
	var currentLocation = global_transform.origin
	var next_location = navAgent.get_next_path_position()
	var newVelocity = (next_location - currentLocation).normalized() * speed
	
	navAgent.set_velocity(newVelocity)
	
	if !withPlayer:
		look_at(navAgent.target_position)
	else:
		var input_dir = Input.get_vector("a_key", "d_key", "w_key", "s_key")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction && !chasing:
			await get_tree().create_timer(0.1).timeout
			bat.look_at(position - direction)
		elif chasing:
			bat.look_at(NpcTarget.position)
	
	if player.Health < 90 && !carryingBlood:
		findNearestNPC()
	else:
		updateTargetLocation(player.position)
		withPlayer = true
	
	$AnimationTree.set("parameters/conditions/idle", !attacking)
	$AnimationTree.set("parameters/conditions/Attack", attacking)

func updateTargetLocation(targetLoc):
	navAgent.target_position = targetLoc

func findNearestNPC():

	var NPCs = get_tree().get_nodes_in_group("NPC")
	
	if !NPCs.is_empty():
		var nearestNPC = NPCs[0]
	
		# look through spawn nodes to see if any are closer
		for npc in NPCs:
			if npc.global_position.distance_to(player.global_position) < nearestNPC.global_position.distance_to(player.global_position):
				nearestNPC = npc
				
		var playerPosition = player.global_transform.origin
		var objectPosition = global_transform.origin
		
		var distance = objectPosition.z - playerPosition.z
		
		if distance < 10 && !carryingBlood && !attacking && !nearestNPC.dead:
			NpcTarget = nearestNPC
			updateTargetLocation(nearestNPC.global_transform.origin)
			chasing = true
		else:
			chasing = false
	else:
		chasing = false

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity,0.25)
	move_and_slide()

func _on_navigation_agent_3d_target_reached():
	if chasing == true && !carryingBlood:
		if attacking == false:
			attacking = true
			attackingNPC()
	elif carryingBlood == true:
		print("Healed player")
		player.healPlayer()
		carryingBlood = false
		
func attackingNPC():
		attacking = true
		print("Killed NPC")
		await  get_tree().create_timer(2).timeout
		NpcTarget.died()
		carryingBlood = true
		print("No longer attacking.")
		attacking = false
		chasing = false

extends NavigationRegion3D

@onready var player = $"../Player"

func _physics_process(delta):
	pass
	#get_tree().call_group("NPC","updateTargetLocation",player.global_transform.origin)

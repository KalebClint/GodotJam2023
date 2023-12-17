extends Camera3D

@onready var player = $"../Player"

func _process(_delta):
	position.z = player.position.z - 5

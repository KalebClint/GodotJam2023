extends Node3D

@onready var sun = $SUNSTUFF/Sun

@onready var player = $Player

var sunSpeed = 0.17

func _physics_process(_delta):
	
	sun.position.z += sunSpeed
	
func aNpcDied(dedNPC):
	get_tree().call_group("NPC","deathHappened",dedNPC)

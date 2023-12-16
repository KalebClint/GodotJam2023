extends Node3D

@onready var sun = $SUNSTUFF/Sun

@onready var player = $Player

var sunSpeed = 0.175

func _physics_process(delta):
	
	sun.position.z += sunSpeed
	
func aNpcDied(dedNPC):
	get_tree().call_group("NPC","deathHappened",dedNPC)

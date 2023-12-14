extends Node3D

@onready var sun = $SUNSTUFF/Sun

@onready var shade = $Camera3D/Shade
@onready var shadeLeft = $Camera3D/ShadeLeft
@onready var shadeRight = $Camera3D/ShadeRight

@onready var sunCollider = $SUNSTUFF/sunColliderMove

@onready var player = $Player

var sunSpeed = 0.06

@onready var sunSpawn = $SUNSTUFF/SunSpawn
	
func _physics_process(delta):
	
	sun.position.z += sunSpeed
	

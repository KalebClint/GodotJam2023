extends Node3D

@onready var sun = $Sun

@onready var shade = $Camera3D/Shade
@onready var shadeLeft = $Camera3D/ShadeLeft
@onready var shadeRight = $Camera3D/ShadeRight

@onready var sunCollider = $Sun/SunCollider

@onready var player = $Player

var daytime = true

var sunIsOverhead = false
var sunIsLeft = true
var sunIsRight = false


# Called when the node enters the scene tree for the first time.
func _ready():
	#Set Sun position
	sun.show()
	sunIsLeft = true
	sunIsOverhead = false
	sunIsRight = false
	
func _physics_process(delta):
	
	sunCollider.position.y = -player.position.z
	
	if daytime:
		sun.rotation.x -= 0.00065




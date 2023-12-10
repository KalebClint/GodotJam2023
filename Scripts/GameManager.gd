extends Node3D

@onready var sun = $SUNSTUFF/Sun

@onready var shade = $Camera3D/Shade
@onready var shadeLeft = $Camera3D/ShadeLeft
@onready var shadeRight = $Camera3D/ShadeRight

@onready var sunCollider = $SUNSTUFF/sunColliderMove

@onready var player = $Player

var sunSpeed = 0.0475

@onready var sunSpawn = $SUNSTUFF/SunSpawn

var daytime = true

var sunIsOverhead = false
var sunIsLeft = true
var sunIsRight = false

var speedUp = 0

var index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#Set Sun position
	sun.show()
	sunIsLeft = true
	sunIsOverhead = false
	sunIsRight = false
	
func _physics_process(delta):
	
	sunCollider.position.z = player.position.z
	
	if daytime:
		index += 0.04
		sun.rotation.x -= 0.00083
		sunCollider.position.x -= sunSpeed
		if index > 100:
			daytime = false
			setNight()
			

func setDay():
	daytime = true
	speedUp = 0
	sun.show()
	index = 0
	sunCollider.position.x = 0
	sun.rotation = sunSpawn.rotation

func setNight():
	sun.hide()
	await get_tree().create_timer(randi_range(30,50)).timeout
	setDay()

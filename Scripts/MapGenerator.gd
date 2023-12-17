extends Node3D

@onready var player = $"../../Player"

@onready var segment = $"../startingSeg/Segment One"

@onready var navReg = $".."

@export var segmentOne:PackedScene
@export var segmentTwo:PackedScene

var rotOfTheSeg

var pos = 0

var totalDuplicationDistance = 0
var firstDuplicationDistance = 84

func _physics_process(_delta):
	var d = player.position.z - totalDuplicationDistance
	if d > -30:
		spawnNewSegement()

func _ready():
	navReg.bake_navigation_mesh(true)
	rotOfTheSeg = segment.rotation
	spawnNewSegement()

func spawnNewSegement():
	var rand = randi_range(1,2)
	if rand == 1:
		var seg = segmentOne.instantiate()
		seg.rotation = rotOfTheSeg
		seg.transform.origin.z += totalDuplicationDistance + firstDuplicationDistance
		add_child(seg)
	elif rand == 2:
		var seg = segmentTwo.instantiate()
		seg.rotation = rotOfTheSeg
		seg.transform.origin.z += totalDuplicationDistance + firstDuplicationDistance
		add_child(seg)

	navReg.bake_navigation_mesh(true)
	totalDuplicationDistance += 84

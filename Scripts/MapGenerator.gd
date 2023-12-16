extends Node3D

@onready var player = $"../Player"

@onready var segment = $"../NavigationRegion3D/Segment One"


@export var segmentOne:PackedScene
@export var segmentTwo:PackedScene
@export var segmentThree:PackedScene
@export var segmentFour:PackedScene

var rotOfTheSeg

var pos = 0

var totalDuplicationDistance = 0
var firstDuplicationDistance = 84

func _physics_process(delta):
	var d = player.position.z - totalDuplicationDistance
	if d > -30:
		spawnNewSegement()

func _ready():
	rotOfTheSeg = segment.rotation
	spawnNewSegement()

func spawnNewSegement():
	var rand = randi_range(1,1)
	if rand == 1:
		var seg = segmentOne.instantiate()
		seg.rotation = rotOfTheSeg
		seg.transform.origin.z += totalDuplicationDistance + firstDuplicationDistance
		add_child(seg)
		print("New SEG!")
	elif rand == 2:
		var seg = segmentTwo.instantiate()
		seg.rotation = rotOfTheSeg
		seg.transform.origin.z += totalDuplicationDistance + firstDuplicationDistance
		add_child(seg)
		print("New SEG!")
	elif rand == 3:
		var seg = segmentOne.instantiate()
		seg.rotation = rotOfTheSeg
		seg.transform.origin.z += totalDuplicationDistance + firstDuplicationDistance
		add_child(seg)
		print("New SEG!")
	elif rand == 4:
		var seg = segmentOne.instantiate()
		seg.rotation = rotOfTheSeg
		seg.transform.origin.z += totalDuplicationDistance + firstDuplicationDistance
		add_child(seg)
		print("New SEG!")

	totalDuplicationDistance += 84

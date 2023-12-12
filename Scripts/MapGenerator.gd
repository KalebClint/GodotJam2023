extends Node3D

@onready var player = $"../Player"

@onready var segment = $"../NavigationRegion3D/segmentOne"


var pos = 0

var totalDuplicationDistance = 0
var firstDuplicationDistance = 84
var rng = RandomNumberGenerator.new()

func _physics_process(delta):
	var d = player.position.z + totalDuplicationDistance
	if d < 20:
		_on_spawntime_timeout()

func _ready():
	_on_spawntime_timeout()

func pickSegment():
	var rand = randi_range(1,2)
	if rand == 1:
		segment = $"../NavigationRegion3D/segmentOne"
	elif rand == 2:
		pass

func _on_spawntime_timeout():
	rng.randomize()
	var levelInstance: Node3D
	var levelInstance2: Node3D
	var randomValue = rng.randf()
	levelInstance = segment.duplicate()
	levelInstance.transform.origin.z -= totalDuplicationDistance + firstDuplicationDistance
	add_child(levelInstance)
	totalDuplicationDistance += 84

extends Node3D

@onready var player = $"../Player"

@onready var originalLevel = $"../NavigationRegion3D/segmentOne"

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

func _on_spawntime_timeout():
	rng.randomize()
	var levelInstance: Node3D
	var levelInstance2: Node3D
	var randomValue = rng.randf()
	levelInstance = originalLevel.duplicate()
	levelInstance.transform.origin.z -= totalDuplicationDistance + firstDuplicationDistance
	add_child(levelInstance)
	totalDuplicationDistance += 84

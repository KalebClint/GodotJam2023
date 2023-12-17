extends Node3D

@export var Angel:PackedScene


@onready var secondPoint = self.get_child(0)
@onready var thirdPoint = self.get_child(1)

@onready var gameManager

# Called when the node enters the scene tree for the first time.
func _ready():
	
	gameManager = get_node("/root")
	
	#Chance to spawn in a NPC
	var rand = randf_range(1,6)
	if rand < 4:
		var enemy = Angel.instantiate()
		add_child(enemy)
		enemy.setPoints(global_transform.origin,secondPoint.global_transform.origin,thirdPoint.global_transform.origin)
		enemy.global_transform.origin = global_transform.origin


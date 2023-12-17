extends Node3D

@export var NpcOne:PackedScene
@export var NpcTwo:PackedScene
@export var NpcThree:PackedScene
@export var NpcFour:PackedScene
@export var NpcFive:PackedScene

@onready var secondPoint = self.get_child(0)
@onready var thirdPoint = self.get_child(1)

@onready var gameManager

# Called when the node enters the scene tree for the first time.
func _ready():
	
	gameManager = get_node("/root")
	
	#Chance to spawn in a NPC
	var rand = randf_range(1,4.5)
	if rand < 4.313:
		rand = randi_range(1,5)
		#Randomly pick which NPC to spawn
		if rand == 1:
			var Npc = NpcOne.instantiate()
			add_child(Npc)
			Npc.setPoints(global_transform.origin,secondPoint.global_transform.origin,thirdPoint.global_transform.origin)
			Npc.global_transform.origin = global_transform.origin
		elif rand == 2:
			var Npc = NpcTwo.instantiate()
			add_child(Npc)
			Npc.setPoints(global_transform.origin,secondPoint.global_transform.origin,thirdPoint.global_transform.origin)
			Npc.global_transform.origin = global_transform.origin
		elif rand == 3:
			var Npc = NpcThree.instantiate()
			add_child(Npc)
			Npc.setPoints(global_transform.origin,secondPoint.global_transform.origin,thirdPoint.global_transform.origin)
			Npc.global_transform.origin = global_transform.origin
		elif rand == 4:
			var Npc = NpcFour.instantiate()
			add_child(Npc)
			Npc.setPoints(global_transform.origin,secondPoint.global_transform.origin,thirdPoint.global_transform.origin)
			Npc.global_transform.origin = global_transform.origin
		elif rand == 5:
			var Npc = NpcFive.instantiate()
			add_child(Npc)
			Npc.setPoints(global_transform.origin,secondPoint.global_transform.origin,thirdPoint.global_transform.origin)
			Npc.global_transform.origin = global_transform.origin

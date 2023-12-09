extends StaticBody3D

@onready var player = $"../../Player"

@onready var gameManager = $"../.."




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_shade_collision_body_entered(body):
	#Check if the object if the player, if so then thye are in shade
	if body.name == "Player":
		player.underShade = true

func _on_shade_collision_body_exited(body):
	#Check if the object if the player, if so then they left shade
	if body.name == "Player":
		player.underShade = false

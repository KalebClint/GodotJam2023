extends Node3D
# Reference to the player
@onready var player = $"../../Player"

@export var cone : PackedScene

# Set the maximum distance behind the player before deleting the object
var maxDistance = -75.0  # Adjust the value based on your needs

func _ready():
	var rand = randi_range(0,5)
	deployCone(rand)

func _process(delta):
	var playerPosition = player.global_transform.origin
	var objectPosition = global_transform.origin

	# Calculate the distance along the Z-axis
	var distance = objectPosition.z - playerPosition.z

	# Check if the distance is greater than the maximum allowed distance
	if distance < maxDistance:
		# Delete the object
		queue_free()
		
func deployCone(amount):
	
	print(amount)
	var index = 0
	
	if amount != 0:
		while index != amount:
			var _cone = cone.instantiate()
			_cone.global_position = global_position
			_cone.global_position.y += 0.2
			_cone.global_position.x += randf_range(2,-2)
			_cone.global_position.z += randf_range(15,-15)
			add_child(_cone)
			index += 1

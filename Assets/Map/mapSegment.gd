extends Node3D

# Reference to the players
@onready var player = $"../../Player"

# Set the maximum distance behind the player before deleting the object
var maxDistance = 75.0  # Adjust the value based on your needs

func _process(delta):
	var playerPosition = player.global_transform.origin
	var objectPosition = global_transform.origin

	# Calculate the distance along the Z-axis
	var distance = objectPosition.z - playerPosition.z

	# Check if the distance is greater than the maximum allowed distance
	if distance > maxDistance:
		# Delete the object
		queue_free()

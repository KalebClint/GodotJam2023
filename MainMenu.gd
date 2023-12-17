extends Control

func _on_play_pressed():
	loadManager.load_scene("res://Scenes/main_scene.tscn")

func _on_quit_pressed():
	get_tree().quit()

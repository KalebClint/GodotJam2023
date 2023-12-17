extends CanvasLayer

@onready var player_ui = $"."

@onready var pause = $Pause
@onready var endGame = $EndGame

@onready var endScore = $EndGame/EndScore

@onready var hungerBar = $hungerBar
@onready var illBar = $illBar

@onready var how_to_play = $HowToPlay
@onready var stanima_bar = $StanimaBar


func _ready():
	get_tree().paused = false
	illBar.show()
	hungerBar.show()
	pause.hide()
	endGame.hide()
	how_to_play.hide()
	stanima_bar.hide()
	await get_tree().create_timer(0.1).timeout
	
	if Global.playedOnce == false:
		how_to_play.show()
		get_tree().paused = true


func _on_quit_pressed():
	get_tree().quit()


func _on_resume_pressed():
	get_tree().paused = false
	pause.hide()


func _on_play_again_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func playerDied(score):
	illBar.hide()
	hungerBar.hide()
	pause.hide()
	get_tree().paused = true
	endGame.show()
	endScore.text = "Score: " + str(score)


func _on_ready_pressed():
	how_to_play.hide()
	Global.playedOnce = true
	get_tree().paused = false

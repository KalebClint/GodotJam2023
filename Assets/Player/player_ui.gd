extends CanvasLayer

@onready var player_ui = $"."

@onready var pause = $Pause
@onready var endGame = $EndGame

@onready var highScore = $EndGame/HighScore
@onready var endScore = $EndGame/EndScore

@onready var hungerBar = $hungerBar
@onready var illBar = $illBar


func _ready():
	illBar.show()
	hungerBar.show()
	pause.hide()
	endGame.hide()


func _on_quit_pressed():
	get_tree().quit()


func _on_resume_pressed():
	get_tree().paused = false
	pause.hide()


func _on_play_again_pressed():
	get_tree().reload_current_scene()


func playerDied(score):
	illBar.hide()
	hungerBar.hide()
	pause.hide()
	get_tree().paused
	endGame.show()
	if score > Global.highscore:
		Global.highscore = score
	endScore.text = str(score)
	highScore = str(Global.highscore)

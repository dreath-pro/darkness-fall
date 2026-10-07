extends Node2D

@onready var game_over_screen = %GameOver

func restart_game() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_restart_button_pressed():
	restart_game()

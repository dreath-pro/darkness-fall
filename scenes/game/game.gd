extends Node2D

@onready var game_over_screen = %GameOver

func spawn_zombie():
	
	var new_zombie = preload("res://scenes/characters/zombie/zombie.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_zombie.global_position = %PathFollow2D.global_position
	add_child(new_zombie)

func restart_game() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_restart_button_pressed():
	restart_game()


func _on_timer_timeout():
	spawn_zombie()

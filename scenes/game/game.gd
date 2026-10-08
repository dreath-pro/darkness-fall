extends Node2D

@onready var game_over_screen = %GameOver

@export var tree_scene: PackedScene = preload("res://scenes/map/tree.tscn")
@export var tree_count: int = 50

@export var spawn_min: Vector2 = Vector2(50, 50)
@export var spawn_max: Vector2 = Vector2(1100, 600)

func _ready() -> void:
	spawn_tree()

func spawn_tree() -> void:
	if tree_scene == null:
		print("Tree is not assigned in the Inspector!")
		return
	
	for i in range(tree_count):
		var random_x = randf_range(spawn_min.x, spawn_max.x)
		var random_y = randf_range(spawn_min.y, spawn_max.y)
		var random_pos = Vector2(random_x, random_y)
		
		var tree_instance = tree_scene.instantiate()
		tree_instance.global_position = random_pos
		
		$Tree.add_child(tree_instance)
	

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

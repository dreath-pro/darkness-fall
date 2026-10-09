extends Node2D

@onready var game_over_screen = %GameOver

@export var med_kit_scene: PackedScene = preload("res://scenes/game/med_kit.tscn")

@export var tree_scene: PackedScene = preload("res://scenes/map/tree.tscn")
@export var tree_count: int = 50

@export var spawn_min: Vector2 = Vector2(50, 50)
@export var spawn_max: Vector2 = Vector2(1100, 600)

@onready var pistol = $Player/Pistol
@onready var ammo_label: Label = %ammo_label

var random_x
var random_y
var random_pos

func _ready() -> void:
	spawn_tree()
	
	pistol.reloading.connect(reloadingLabel)
	reloadingLabel(pistol.is_reloading)
	
	pistol.ammo_changed.connect(_on_pistol_ammo_changed)
	_on_pistol_ammo_changed(pistol.mag_ammo, pistol.reserve_ammo)
	

func reloadingLabel(isReloading: bool) -> void:
	if isReloading:
		ammo_label.text = "Reloading"

func _on_pistol_ammo_changed(current: int, reserve: int) -> void:
	ammo_label.text = "%d / %d" % [current, reserve]

func spawnRandomizer() -> void:
	random_x = randf_range(spawn_min.x, spawn_max.x)
	random_y = randf_range(spawn_min.y, spawn_max.y)
	random_pos = Vector2(random_x, random_y)

func spawn_med_kit() -> void:
	if med_kit_scene == null:
		print("Med Kit is not assigned in the Inspector!")
		return
		
	spawnRandomizer()
		
	var med_kit_instance = med_kit_scene.instantiate()
	med_kit_instance.global_position = random_pos
		
	add_child(med_kit_instance)

func spawn_tree() -> void:
	if tree_scene == null:
		print("Tree is not assigned in the Inspector!")
		return
	
	for i in range(tree_count):
		spawnRandomizer()
		
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


func _on_med_kit_spawn_timer_timeout():
	spawn_med_kit()

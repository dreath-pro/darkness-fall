extends Node2D

var damage = 350
const BULLET = preload("res://scenes/weapons/bullet.tscn")

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
			
			
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	var new_bullet = BULLET.instantiate()
	get_tree().root.add_child(new_bullet)
	new_bullet.damage = damage
	new_bullet.global_position = %Barrel.global_position
	new_bullet.global_rotation = %Barrel.global_rotation
	

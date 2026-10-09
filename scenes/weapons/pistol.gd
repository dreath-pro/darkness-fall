extends Node2D

var damage = 350

@export var max_mag = 8
var mag_ammo = max_mag
var reserve_ammo = 40
signal ammo_changed(mag_ammo: int, reserve_ammo: int)
signal reloading(reloading: bool)

@onready var reload_timer: Timer = $ReloadTimer
var is_reloading: bool = false

const BULLET = preload("res://scenes/weapons/bullet.tscn")

func _ready() -> void:
	ammo_changed.emit(mag_ammo, reserve_ammo)

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
	if is_reloading:
		return
	else:
		if mag_ammo > 0:
			var new_bullet = BULLET.instantiate()
			get_tree().root.add_child(new_bullet)
			
			new_bullet.damage = damage
			new_bullet.global_position = %Barrel.global_position
			new_bullet.global_rotation = %Barrel.global_rotation
			
			mag_ammo -= 1
			ammo_changed.emit(mag_ammo, reserve_ammo)
		else:
			reload()

func reload():
	for i in max_mag:
		if reserve_ammo <= 0:
			return
		elif mag_ammo > max_mag:
			return
		elif is_reloading:
			return
	
	
		mag_ammo += 1
		reserve_ammo -= 1

	is_reloading = true
	reloading.emit(is_reloading)
	reload_timer.start()

func _on_reload_timer_timeout():
	is_reloading = false
	ammo_changed.emit(mag_ammo, reserve_ammo)

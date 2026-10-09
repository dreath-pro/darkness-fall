extends Area2D

@export var heal_amount = 400
@export var blink_duration: float = 3.8
@export var blink_frequency: float = 0.1

@onready var sprite: Sprite2D = $Sprite2D
@onready var despawn_timer: Timer = $DispawnTimer

var is_blinking: bool = false

func _ready() -> void:
	var wait_before_blink: float = max(0.0, despawn_timer.wait_time - blink_duration)
	
	if wait_before_blink > 0:
		await get_tree().create_timer(wait_before_blink).timeout
		
	start_blinking()


func start_blinking() -> void:
	if is_blinking:
		return
	is_blinking = true
	
	var loops: int = int(blink_duration / (blink_frequency * 2))
	var tween: Tween = create_tween().set_loops(loops)
	
	tween.tween_property(sprite, "modulate:a", 0.2, blink_frequency)
	tween.tween_property(sprite, "modulate:a", 1.0, blink_frequency)
	

func _on_body_entered(body):
	if body.has_method("receive_heal"):
		body.receive_heal(heal_amount)
		queue_free()

func _on_dispawn_timer_timeout():
	queue_free()

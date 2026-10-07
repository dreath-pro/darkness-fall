extends CharacterBody2D

var health = 1500
var damage = 250

@onready var player = get_node("/root/Game/Player")
@onready var healthbar = %EnemyHealth

func _ready():
	player = get_node("/root/Game/Player")
	healthbar.max_value = health

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 40
	move_and_slide()

func take_damage(amount):
	health -= amount
	
	healthbar.visible = true
	healthbar.value = health
	
	if health <= 0:
		queue_free()


func _on_health_disappear_timeout():
	healthbar.visible = false

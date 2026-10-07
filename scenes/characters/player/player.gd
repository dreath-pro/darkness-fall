extends CharacterBody2D

var health = 2300.0
signal health_depleted
@onready var healthbar = %Health

func _ready():
	healthbar.max_value = health
	healthbar.value = health

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 230
	move_and_slide()
	
	var touching_zombie = %Hitbox.get_overlapping_bodies()
	if touching_zombie.size() > 0:
		for zombie in touching_zombie:
			if "damage" in zombie:
				take_damage(zombie.damage * delta)


func take_damage(amount: float):
	health -= amount
	health = max(0, health)
	healthbar.value = health
	
	if health <= 0.0:
		health_depleted.emit()


func _on_health_depleted():
	%GameOver.visible = true
	get_tree().paused = true

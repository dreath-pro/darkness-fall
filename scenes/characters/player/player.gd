extends CharacterBody2D

const max_health = 2300.0
var health = max_health
signal health_depleted
@onready var healthbar = %Health

var energy = 100
@onready var energybar = %Energy

func _ready():
	healthbar.max_value = health
	healthbar.value = health
	
	energybar.max_value = energy
	energybar.value = energy

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reload") and not event.is_echo():
		print("Reloading")
		$Pistol.reload()

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_pressed("sprint") and direction != Vector2.ZERO and energy > 0:
		velocity = direction * 300
		drain_energy(30 * delta)
	else:
		velocity = direction * 150
	move_and_slide()
	
	var touching_zombie = %Hitbox.get_overlapping_bodies()
	if touching_zombie.size() > 0:
		for zombie in touching_zombie:
			if "damage" in zombie:
				take_damage(zombie.damage * delta)

func drain_energy(amount: float):
	energy -= amount
	energy = max(0, energy)
	energybar.value = energy


func receive_heal(amount: float):
	health += amount
	
	if health >= max_health:
		health = max_health
		
	healthbar.value = health

func take_damage(amount: float):
	health -= amount
	health = max(0, health)
	healthbar.value = health
	
	if health <= 0.0:
		health_depleted.emit()

func _on_health_depleted():
	%GameOver.visible = true
	get_tree().paused = true


func _on_timer_timeout():
	energy += 2
	
	if energy >= 100:
		energy = 100
	
	energybar.value = energy

extends Node2D
class_name HealthComponent

@export var maxHealth : int
@export var health : int

var parent

signal player_damage

func _ready():
	health = maxHealth

func damage():
	health -= 1
	if owner.name == "Player":
		emit_signal("player_damage")
	
	if health <= 0:
		die()

func die():
	owner.currentMovement = owner.movement.dying
	pass

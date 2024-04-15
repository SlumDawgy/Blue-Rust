extends Node2D
class_name HealthComponent

@export var maxHealth : int
@export var health : int

func _ready():
	health = maxHealth

func damage(attack):
	health -= attack.damage
	
	if health <= 0:
		die()

func die():
	pass

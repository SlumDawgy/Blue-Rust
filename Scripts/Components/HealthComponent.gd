extends Node2D
class_name HealthComponent

@export var maxHealth : int = 3
var health : int 

@onready var parent : CharacterBody2D = get_parent()

func _ready():
	health = maxHealth

func damage(attack):
	health -= attack.damage
	if health > 0:
		parent.currentMovement = parent.movement.takingDamage
		parent.position.x += attack.knockback * attack.direction
	else:
		parent.currentMovement = parent.movement.dying

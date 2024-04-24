extends Node2D
class_name HealthComponent

@export var maxHealth : int = 3
var health : int 
var damageImmunityTimer : float
@export var damageImmunity : float

@onready var parent : CharacterBody2D = get_parent()

func _ready():
	health = maxHealth
	damageImmunityTimer = damageImmunity

func _process(delta):
	damageImmunityTimer -= delta

func damage(attack):
	if damageImmunityTimer <= 0:
		health -= attack.damage
	damageImmunityTimer = damageImmunity
	if health > 0:
		parent.currentMovement = parent.movement.takingDamage
		parent.velocity.x = attack.knockback * 2 * attack.direction
		parent.velocity.y = attack.knockupwards
	else:
		parent.currentMovement = parent.movement.dying

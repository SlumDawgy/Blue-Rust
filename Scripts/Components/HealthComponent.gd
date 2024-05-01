extends Node2D
class_name HealthComponent

@export var maxHealth : int = 3
var health : int 
var damageImmunityTimer : float
@export var damageImmunity : float

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
		get_parent().currentMovement = get_parent().movement.takingDamage
		get_parent().velocity.x = attack.knockback * 2 * attack.direction
		get_parent().velocity.y = attack.knockupwards
	else:
		get_parent().currentMovement = get_parent().movement.dying

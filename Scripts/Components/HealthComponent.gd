extends Node2D
class_name HealthComponent

@export var maxHealth : int = 3
var health : int 
var damageImmunityTimer : float
@export var damageImmunity : float

#breath
@export var maxBreath: = 5
var currentBreath
@export var holdBreathTime: float = 10
var holdBreathTimer : float


func _ready():
	health = maxHealth
	currentBreath = maxBreath
	damageImmunityTimer = damageImmunity

func _process(delta):
	damageImmunityTimer -= delta

func damage(attack):
	if damageImmunityTimer <= 0 and health > 0:
		
		health -= attack.damage
		damageImmunityTimer = damageImmunity
		var knockbackX : int = attack.knockback * 2 * attack.direction
		var knockbackY : int = attack.knockupwards
		get_parent().handleKnockback(knockbackX, knockbackY)
			
			
	
	

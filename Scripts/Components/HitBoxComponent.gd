extends Area2D
class_name HitBoxComponent

@export var healthComponentInstance : HealthComponent

func damage(attack):
	healthComponentInstance.damage(attack)

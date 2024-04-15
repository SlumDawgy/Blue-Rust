extends Area2D
class_name HitBoxComponent

@export var healthComponentInstance : HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func damage(attack):
	healthComponentInstance.damage(attack)

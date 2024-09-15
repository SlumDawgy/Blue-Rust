extends Area2D

@onready var player = $".."
@onready var healthComponent = $"../HealthComponent"


func _on_body_entered(body):
	pass
	


func _on_body_exited(body):
	pass


func _on_area_entered(area):
	
	if area.name == "Water":
		player.isInWaterOverHead = true


func _on_area_exited(area):
	if area.name == "Water":
		player.isInWaterOverHead = false
		healthComponent.holdBreathTimer =  healthComponent.holdBreathTime
		healthComponent.currentBreath = healthComponent.maxBreath

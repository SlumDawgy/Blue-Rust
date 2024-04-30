extends Area2D

class WaterDamage:
	var damage : int = 1
	var knockback : int = 25
	var direction : int = 1
	var knockupwards : int = -300

func _on_body_entered(body):
	
	if body.name == "Player":
		body.currentMovement = body.movement.takingDamage
		var waterDamage = WaterDamage.new()
		body.get_node("HitBoxComponent").damage(waterDamage)

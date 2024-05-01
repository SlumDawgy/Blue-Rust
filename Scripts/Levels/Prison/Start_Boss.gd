extends Area2D
@export var Boss : Enemy

#func _on_body_entered(_body : Player):
	#$"../../Audio/MainLevelTheme".playing = false
	#$"../../Audio/BossFight".playing = true
	#queue_free()
	#Boss.player = _body
	#Boss.currentMovement = Boss.movement.enabled 
	#

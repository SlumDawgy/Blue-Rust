extends Node2D
@export var player : Player

func PowerUp(body):
	if body.name == "HitBoxComponent":
		player.get_node("PlayerSprite").playAnimation("idle")
		player.currentMovement = player.movement.disabled
		player.dashEnabled = true
		get_tree().root.get_node("Prison").get_node("powerUp").queue_free()
		Dialogic.start("res://Dialogic/Timelines/Prison1-5.dtl")


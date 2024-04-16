extends Area2D

func _on_body_entered(body : Player):
	$"../AudioStreamPlayer".playing = false
	$"../BossFight".playing = true

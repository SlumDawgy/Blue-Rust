extends Area2D

func _on_body_entered(_body : Player):
	$"../AudioStreamPlayer".playing = false
	$"../BossFight".playing = true

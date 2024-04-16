extends Area2D

func _on_body_entered(body : Player):
	$"../First_Boss".set_physics_process(true)
	$"../AudioStreamPlayer".playing = false
	$"../BossFight".playing = true

extends Area2D





func _on_area_entered(area):
	if area.name == "LightSwitch":
		get_parent().enabled = true



func _on_area_exited(area):
	if area.name == "LightSwitch":
		get_parent().enabled = false


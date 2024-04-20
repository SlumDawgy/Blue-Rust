extends Area2D

func _on_area_exited(area : Grapple):
	area.returning = true

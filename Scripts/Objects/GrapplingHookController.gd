extends Area2D

var grappleSpeed : int = 200
var maxGrappleRange : int = 50

@onready var audio : Node2D = get_node("sfx")





func _physics_process(delta):
	position += transform.x * grappleSpeed * delta


func _on_area_shape_exited(area_rid, area):
	print(area)


func _on_max_grapple_range_area_exited(area):
	print('here')


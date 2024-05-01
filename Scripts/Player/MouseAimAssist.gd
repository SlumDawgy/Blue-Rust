extends ShapeCast2D

@onready var aimAssisted = preload("res://Scenes/Player/aim_assisted.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_global_mouse_position()
	if is_colliding() and get_collider(0).is_class("TileMap") and owner.get_node_or_null("AimAssisted") != null:
		var coords = get_collider(0).get_coords_for_body_rid(get_collider_rid(0))
		owner.get_node_or_null("AimAssisted").position = get_collider(0).map_to_local(coords)
	elif is_colliding() and get_collider(0).is_class("TileMap"):
		var aimAssistInstance = aimAssisted.instantiate()
		var coords = get_collider(0).get_coords_for_body_rid(get_collider_rid(0))
		aimAssistInstance.position = get_collider(0).map_to_local(coords)
		aimAssistInstance.name = "AimAssisted"
		owner.add_child(aimAssistInstance)
	elif not is_colliding() and owner.get_node_or_null("AimAssisted") != null:
			owner.get_node("AimAssisted").queue_free()

extends Area2D

var player

func _ready():
	player = get_parent()


func _on_damage_collision_body_shape_entered(body_rid, body, _body_shape_index, _local_shape_index):
	
	if body.is_in_group("Tile"):
		var coords = body.get_coords_for_body_rid(body_rid)
		if body.get_cell_tile_data(0, coords).get_custom_data("CollisionType") == "Water":
			player.takingDamage = true


func _on_damage_collision_body_shape_exited(body_rid, body, _body_shape_index, _local_shape_index):
	if body.is_in_group("Tile"):
		var coords = body.get_coords_for_body_rid(body_rid)
		if body.get_cell_tile_data(0, coords).get_custom_data("CollisionType") == "Water":
			player.takingDamage = false
	pass # Replace with function body.

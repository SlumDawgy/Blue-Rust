extends Area2D

var aiming

# Called when the node enters the scene tree for the first time.
func _ready():
	aiming = preload(GlobalPaths.PLAYER_AIMING_PATH)
	pass # Replace with function body.

func _on_mouse_follower_body_shape_entered(body_rid, body, _body_shape_index, _local_shape_index):
	var player = get_parent()
	
	if player.aimAssistActive == true:
		if body.is_in_group("Tile"):
			
			var coords = body.get_coords_for_body_rid(body_rid)
		# Find Grapplable Object and move Player
			if body.get_cell_tile_data(1, coords) != null:
				if body.get_cell_tile_data(1, coords).get_custom_data("CollisionType") == "Grapple":
					if player.get_parent().get_node_or_null("aimAssist") != null:
						player.get_parent().get_node("aimAssist").position = body.map_to_local(coords)
					if player.get_parent().get_node_or_null("aimAssistArea") != null:
						player.get_parent().get_node("aimAssistArea").position = body.map_to_local(coords)
					
					
					else:
					
						var aimAssist = Sprite2D.new()
						
						aimAssist.texture = aiming
						aimAssist.name = "aimAssist"
						aimAssist.position = body.map_to_local(coords)
						
						player.get_parent().add_child(aimAssist)
						
						var aimAssistArea = Area2D.new()
						aimAssistArea.name = "aimAssistArea"
						
						var aimAssistAreaCollision = CollisionShape2D.new()
						
						aimAssistAreaCollision.shape = CircleShape2D.new()
						aimAssistAreaCollision.shape.set_radius(64)
						
						aimAssistArea.connect("area_shape_exited", Callable(self, "_on_aimAssistArea_area_shape_exited"))
						aimAssistArea.position = body.map_to_local(coords)
						aimAssistArea.collision_layer = 2
						aimAssistArea.collision_mask = 2
						
						aimAssistArea.call_deferred("add_child", aimAssistAreaCollision)
						
						
						player.get_parent().call_deferred("add_child",aimAssistArea)

func _on_aimAssistArea_area_shape_exited(_area_rid, area, _area_shape_index, _local_shape_index):
	var player = get_parent()
	if player.aimAssistActive == true:
		if area != null:
			if area.is_in_group("Mouse"):
				if player.get_parent().get_node_or_null("aimAssist") != null:
					player.get_parent().get_node("aimAssist").free()
			
				if player.get_parent().get_node_or_null("aimAssistArea") != null:
					aimAssistAreaFree()

func aimAssistAreaFree():
	var player = get_parent()
	player.get_parent().get_node("aimAssistArea").queue_free()


	pass # Replace with function body.

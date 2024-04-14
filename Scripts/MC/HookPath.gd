extends Line2D
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(_delta):
	#get_hookPath()
	#
#
#func get_hookPath():
	##pass	
	##var parent = get_parent()
	#var player = get_tree().get_first_node_in_group("Player")
	##
	##if points.has(parent.position):
		##pass
	##else:
		##add_point(parent.position)
	##
	#if player.hookPathActive == true:
		#
		#if get_point_count() > 1:
			#remove_point(1)
		#
		#if player.get_parent().get_node_or_null("Grappling") != null:
			#add_point(to_local(player.get_parent().get_node("Grappling").position))
		#elif player.get_parent().get_node_or_null("aimAssist") != null:
			#add_point(to_local(player.get_parent().get_node("aimAssist").position))
		#else:
			#add_point(get_local_mouse_position())
	#else:
		#clear_points()

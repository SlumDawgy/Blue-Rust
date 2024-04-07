extends Line2D




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	get_hookPath()
	
	pass

func get_hookPath():
	var parent = get_parent()
	var player = get_tree().get_first_node_in_group("Player")
	
	if points.has(parent.position):
		pass
	else:
		add_point(parent.position)
	
	if player.hookPathActive == true:
		
		if get_point_count() > 1:
			remove_point(1)
		
		if player.get_parent().get_node_or_null("Grappling") != null:
			add_point(to_local(player.get_parent().get_node("Grappling").position).normalized() * 128)
			
		elif player.get_parent().get_node_or_null("aimAssist") != null:
			add_point(to_local(player.get_parent().get_node("aimAssist").position).normalized() * 128)
		else:
			add_point(get_local_mouse_position().normalized() * 128)
	else:
		clear_points()

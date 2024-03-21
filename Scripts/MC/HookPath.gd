extends Line2D




# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	get_hookPath()
	
	pass

func get_hookPath():
	var player = get_parent()
	
	if points.has(to_local(player.position)):
		pass
	else:
		add_point(to_local(player.position))
	
	if player.hookPathActive == true:
		
		if get_point_count() > 1:
			remove_point(1)
		if player.get_parent().get_node_or_null("Grappling") != null:
			add_point(player.get_parent().get_node("Grappling").positionToReach.normalized() * 128)
		elif player.get_parent().get_node_or_null("aimAssist") != null:
			add_point(to_local(player.get_parent().get_node("aimAssist").position).normalized() * 128)
		else:
			add_point(get_local_mouse_position().normalized() * 128)
	else:
		clear_points()

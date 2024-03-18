extends AnimatedSprite2D

@onready var armPivo = $Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if animation.begins_with("left"):
		armPivo.get_node("Sprite2D").flip_v = true
		armPivo.get_node("Sprite2D").position.x = -4.5
		armPivo.get_node("Sprite2D").z_index = -1
		armPivo.look_at(get_global_mouse_position())
		armPivo.rotation_degrees += 180
	if animation.begins_with("right"):
		armPivo.get_node("Sprite2D").flip_v = false
		armPivo.get_node("Sprite2D").position.x = 4.5
		armPivo.get_node("Sprite2D").z_index = 0
		armPivo.look_at(get_global_mouse_position())
	
	movingPivot()
	
	pass

func movingPivot():
	if animation == "right_running":
		match frame:
				0: armPivo.position = Vector2(2, -4.5)
				1: armPivo.position = Vector2(3, -6.5)
				2: armPivo.position = Vector2(2, -6.5)
				3: armPivo.position = Vector2(4, -5.5)
				4: armPivo.position = Vector2(3, -4.5)
				5: armPivo.position = Vector2(3, -6.5)
				6: armPivo.position = Vector2(3, -5.5)
				7: armPivo.position = Vector2(5, -5.5)
	elif animation == "right_jump":
		match frame:
				0: armPivo.position = Vector2(-2, -7.5)
				1: armPivo.position = Vector2(-2, -7.5)
	elif animation == "right_fall":
		match frame:
				0: armPivo.position = Vector2(-2, -8.5)
				1: armPivo.position = Vector2(-2, -8.5)
	elif animation == "right_idle":
		armPivo.position = Vector2(-2, -7.5)
	
	elif animation == "left_running":
		match frame:
				0: armPivo.position = Vector2(-7, -4.5)
				1: armPivo.position = Vector2(-6, -6.5)
				2: armPivo.position = Vector2(-4, -6.5)
				3: armPivo.position = Vector2(-5, -5.5)
				4: armPivo.position = Vector2(-6, -4.5)
				5: armPivo.position = Vector2(-7, -6.5)
				6: armPivo.position = Vector2(-3, -5.5)
				7: armPivo.position = Vector2(-3, -5.5)
	elif animation == "left_idle":
		armPivo.position = Vector2(-2, -4.5)
	elif animation == "left_jump":
		armPivo.position = Vector2(0, -4.5)
		pass
	elif animation == "right_fall":
		match frame:
				0: armPivo.position = Vector2(1, -5.5)
				1: armPivo.position = Vector2(1, -5.5)
	
	
	if animation == "right_mantling" or animation == "right_hanging":
		armPivo.visible = false
	else:
		armPivo.visible = true

extends AnimatedSprite2D

@onready var armPivo = $Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	armPivo.look_at(get_global_mouse_position())
	movingPivot()
	pass

func movingPivot():
	if animation == "running2":
		match frame:
				0: armPivo.position = Vector2(2, -4.5)
				1: armPivo.position = Vector2(3, -6.5)
				2: armPivo.position = Vector2(2, -6.5)
				3: armPivo.position = Vector2(4, -5.5)
				4: armPivo.position = Vector2(3, -4.5)
				5: armPivo.position = Vector2(3, -6.5)
				6: armPivo.position = Vector2(3, -5.5)
				7: armPivo.position = Vector2(5, -5.5)
	elif animation == "jump2":
		match frame:
				0: armPivo.position = Vector2(-2, -7.5)
				1: armPivo.position = Vector2(-2, -7.5)
	elif animation == "fall2":
		match frame:
				0: armPivo.position = Vector2(-2, -8.5)
				1: armPivo.position = Vector2(-2, -8.5)
	elif animation == "Idle":
		armPivo.position = Vector2(-2, -7.5)
	
	
	if animation == "mantling":
		armPivo.visible = false
	else:
		armPivo.visible = true

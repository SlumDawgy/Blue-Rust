extends Sprite2D

@export var speed : float = 2.0

func  _process(delta):
	global_rotation_degrees += speed *delta

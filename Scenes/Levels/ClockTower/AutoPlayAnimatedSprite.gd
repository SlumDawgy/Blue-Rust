extends AnimatedSprite2D

@onready var anim : AnimatedSprite2D

func _ready():
	anim = self
	anim.play("default")

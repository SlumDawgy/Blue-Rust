extends Node2D

var canDo : bool = true

func _process(delta):
	if owner.doubleJumpEnabled:
		if owner.is_on_floor() == false and canDo == true and Input.is_action_just_pressed("Jump") and owner.currentMovement == owner.movement.jumping:
			canDo = false
			owner.jumped = true
		
		if owner.is_on_floor() and canDo == false:
			canDo = true

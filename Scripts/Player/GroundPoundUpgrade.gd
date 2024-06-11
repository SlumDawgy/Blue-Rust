extends Node2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if owner.groundPoundEnabled == true:
		if Input.is_action_just_pressed("GroundPound") and not owner.is_on_floor():
			owner.currentMovement = owner.movement.pounding
	pass

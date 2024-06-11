extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if owner.parasolEnabled:
		if Input.is_action_just_pressed("Parasol") and not owner.is_on_floor():
			owner.currentMovement = owner.movement.gliding

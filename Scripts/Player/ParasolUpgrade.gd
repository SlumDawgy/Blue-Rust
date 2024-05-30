extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if owner.parasolEnabled:
		if Input.is_action_just_pressed("Parasol") and not owner.is_on_floor():
			owner.audio.playrandom(owner.audio.parasolOpen_A, owner.audio.parasolOpen_B)
			owner.currentMovement = owner.movement.gliding

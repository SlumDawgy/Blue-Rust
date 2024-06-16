extends Node2D

@onready var poundTimer = $GroundPoundTimer
@onready var collider = $GroundPoundCollider

@onready var StartParticles = $GroundPoundStartParticles
@onready var ActiveParticles = $GroundPoundActiveParticles
@onready var EndParticles = $GroundPoundEndParticles

var canPound : bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if owner.groundPoundEnabled == true and canPound == true:
		if Input.is_action_just_pressed("GroundPound") and not owner.is_on_floor() and owner.currentMovement != owner.movement.pounding:
			StartParticles.emitting = true
			owner.velocity.y = 0
			canPound = false
			collider.enabled = true
			owner.currentMovement = owner.movement.pounding
			poundTimer.start(0.05)
	if owner.is_on_floor():
		ActiveParticles.emitting = false
		canPound = true

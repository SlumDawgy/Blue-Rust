extends AnimatedSprite2D

@export var FirstBoss : Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func chooseAnimations():
	match FirstBoss.currentMovement:
		FirstBoss.movement.starting:
			pass
		FirstBoss.movement.enabled:
			play(FirstBoss.healthState[FirstBoss.healthStateCounter] + "_Walk")
		FirstBoss.movement.attacking:
			play(FirstBoss.healthState[FirstBoss.healthStateCounter] + "_Slash")
		FirstBoss.movement.charging:
			play(FirstBoss.healthState[FirstBoss.healthStateCounter] + "_Charge")
		FirstBoss.movement.chargeAttacking:
			play(FirstBoss.healthState[FirstBoss.healthStateCounter] + "_Walk")
		FirstBoss.movement.chargingSteam:
			play(FirstBoss.healthState[FirstBoss.healthStateCounter] + "_Steam")
		FirstBoss.movement.steamAttacking:
			pass
		FirstBoss.movement.stunned:
			play(FirstBoss.healthState[FirstBoss.healthStateCounter] + "_Stunned")
		FirstBoss.movement.leavingStun:
			if animation != FirstBoss.healthState[FirstBoss.healthStateCounter] + "_BackUp":
				play(FirstBoss.healthState[FirstBoss.healthStateCounter] + "_BackUp")
			if frame == 5:
				FirstBoss.currentMovement = FirstBoss.movement.enabled
		FirstBoss.movement.takingDamage:
			play(FirstBoss.healthState[FirstBoss.healthStateCounter] + "_Damage")

	if FirstBoss.currentMovement == FirstBoss.movement.chargeAttacking:
		speed_scale = 3
	else:
		speed_scale = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	chooseAnimations()

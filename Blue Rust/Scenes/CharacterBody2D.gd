extends CharacterBody2D

@onready var jumpBufferingCast = $RayCast2D

# Movement Variables
const SPEED = 120.0
const JUMP_VELOCITY = -200.0

# Jump Variables
var coyoteTime = 0.01
var jumpBuffering = false
var doubleJump = false


# Power Ups
var doubleJumpUpgrade = true


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * 0.5
		coyoteTime -= delta * 3
	
	# Add Jump Buffering
	if jumpBufferingCast.is_colliding() and Input.is_action_just_pressed("Jump"):
			jumpBuffering = true
	
	# Is On Floor activations
	if is_on_floor():
		coyoteTime = 0.5
		if doubleJumpUpgrade == true:
			doubleJump = true

	# Jump + Jump Buffering + Coyote Time
	if (Input.is_action_just_pressed("Jump") and coyoteTime > 0) or (jumpBuffering and is_on_floor()):
		velocity.y = JUMP_VELOCITY
		coyoteTime = -1
		jumpBuffering = false

	# Movement Left / Right
	var direction = Input.get_axis("MoveLeft", "MoveRight")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Double Jump
	if doubleJump == true and Input.is_action_just_pressed("Jump") and is_on_floor() == false:
		velocity.y = JUMP_VELOCITY
		doubleJump = false

	move_and_slide()

func doubleJumpActivation():
	doubleJumpUpgrade = true

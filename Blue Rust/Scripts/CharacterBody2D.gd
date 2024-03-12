extends CharacterBody2D

@onready var jumpBufferingCast = $RayCast2D2

# Movement Variables
const SPEED = 120.0
const JUMP_VELOCITY = -200.0

# Jump Variables
var coyoteTime = 0.01
var jumpBuffering = false
var doubleJump = false

# GrapplingHook
var isGrappling = false
var positionToReach : Vector2
var grapplingHook

# Power Ups
var doubleJumpUpgrade = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	grapplingHook = preload("res://Scenes/Grappling.tscn")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and isGrappling == false:
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
	if direction and isGrappling == false:
		velocity.x = direction * SPEED
	elif isGrappling == false:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Double Jump
	if doubleJump == true and Input.is_action_just_pressed("Jump") and is_on_floor() == false:
		velocity.y = JUMP_VELOCITY
		doubleJump = false

	move_and_slide()
	
	# Grappling Hook
	if Input.is_action_just_pressed("GrapplingHook") and get_parent().get_node("Grappling") == null:
		grapplingHookAction()

func doubleJumpActivation():
	doubleJumpUpgrade = true


# Grappling Hook Skill
func grapplingHookAction():
	var grapplingHookChild = grapplingHook.instantiate()
	
	grapplingHookChild.positionToReach = get_local_mouse_position()
	grapplingHookChild.position = get_global_transform().origin
	
	get_parent().add_child(grapplingHookChild)

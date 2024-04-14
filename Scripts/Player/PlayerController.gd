extends CharacterBody2D
class_name Player

# Movements
var currentMovement : int
@export var speed : float = 115.0

# Jump Variables
@export var jumpSpeed : float = -250.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumped : bool = false

var gravityVarUpwards : float = 0.45
var gravityVarDownwards : float = 0.65

var coyoteTime : float = 0.01

# Mantle
@onready var mantleChecker : Node2D = $MantleCheckerComponent
var canMantle : bool = true

# Grappling
var grapplingHookProjectile : PackedScene

# Inputs
var inputDirection : int = 0
var inputJump : bool = false

enum movement
{
	disabled,
	enabled,
	jumping,
	mantling,
	grappling,
	hanging,
	dashing,
	dying
}
	

# Called when the node enters the scene tree for the first time.
func _ready():
	currentMovement = movement.enabled
	grapplingHookProjectile = preload(GlobalPaths.GRAPPLING_HOOK_PATH)
	pass # Replace with function body.

func getInput():
	inputDirection = Input.get_axis("MoveLeft", "MoveRight")

func enabled(delta):
	velocity.x = speed * inputDirection
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		currentMovement = movement.jumping
		jumped = true
		
	if Input.is_action_just_pressed("GrapplingHook"):
		currentMovement = movement.grappling
	
	#Gravity
	if not is_on_floor() and velocity.y >= 0:
		currentMovement = movement.jumping

func jumping(delta):
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y = 0
		pass
	velocity.x = speed * inputDirection
	if jumped == true:
		velocity.y = jumpSpeed
		jumped = false

	#Gravity
	if not is_on_floor() and velocity.y < 0:
		velocity.y += delta * gravity * gravityVarUpwards
	elif not is_on_floor() and velocity.y >= 0:
		velocity.y += delta * gravity * gravityVarDownwards
		if canMantle == true:
			mantleChecker.process_mode = Node.PROCESS_MODE_INHERIT
		
	if is_on_floor() and velocity.y >= 0:
			currentMovement = movement.enabled
			canMantle = true
	
func mantling():
	if velocity.y != 0:
		velocity.y = 0
	if Input.is_action_just_pressed("Crouch"):
		canMantle = false
		currentMovement = movement.enabled
		mantleChecker.process_mode = Node.PROCESS_MODE_DISABLED
	if Input.is_action_just_pressed("Jump"):
		jumped = true
		currentMovement = movement.jumping
		canMantle = true
		pass

func grappling(delta):
	velocity.y = gravity * delta * 1.5
	var grapplingHookChild = grapplingHookProjectile.instantiate()

	if get_tree().root.get_node_or_null("Node2D/Grappling") == null:
		get_parent().add_child(grapplingHookChild)

func _physics_process(delta):
	getInput()
	print(velocity.y)

	match currentMovement:
		movement.disabled:
			pass
		movement.enabled:
			enabled(delta)
		movement.jumping:
			jumping(delta)
		movement.mantling:
			mantling()
		movement.grappling:
			grappling(delta)
		movement.hanging:
			pass
		movement.dashing:
			pass
		movement.dying:
			pass
	
	move_and_slide()

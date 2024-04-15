extends CharacterBody2D
class_name Player

# Physics "Constants"
var GRAVITY : float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Movements
var currentMovement : int
@export var speed : float = 115.0

# Jump Variables
@export var jumpSpeed : float = -250.0
var jumped : bool = false

var gravityModifier : float = 0.65
var gravityVarUpwards : float = 0.45
var gravityVarDownwards : float = 0.65
var gravityVarGrapple : float = 0.01

var coyoteTime : float = 0.01

# Mantle
@onready var mantleChecker : MantleCheckerComponent = $MantleCheckerComponent
var canMantle : bool = true

# Grappling
var grapplingHookScene : PackedScene = preload(GlobalPaths.GRAPPLING_HOOK_PATH)
var grapplingHook : Area2D

# Inputs
var inputDirection : float = 0.0
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

func _ready():
	currentMovement = movement.enabled

func getInput():
	inputDirection = Input.get_axis("MoveLeft", "MoveRight")

func enabled():
	$PlayerSprite/ArmPivo/Arm.look_at(get_global_mouse_position())
	velocity.x = speed * inputDirection
	
	if Input.is_action_just_pressed("GrapplingHook"):
		gravityModifier = gravityVarGrapple
		currentMovement = movement.grappling
		return
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		currentMovement = movement.jumping
		gravityModifier = gravityVarUpwards
		jumped = true
		return
		
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		currentMovement = movement.enabled
		gravityModifier = gravityVarDownwards
		velocity.y = 0
		return
		
	if not is_on_floor() and velocity.y >= 0:
		gravityModifier = gravityVarDownwards
		if canMantle == true:
			mantleChecker.process_mode = Node.PROCESS_MODE_INHERIT
		return

func jumping():
	velocity.x = speed * inputDirection
	if jumped == true:
		velocity.y = jumpSpeed
		jumped = false

	canMantle = true		
	currentMovement = movement.enabled

	
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

func grappling():
	if not grapplingHook:
		grapplingHook = grapplingHookScene.instantiate()
		owner.add_child(grapplingHook)
		grapplingHook.transform = $PlayerSprite/ArmPivo/Arm/GrappleOrigin.get_global_transform()
		grapplingHook.rotation = $PlayerSprite/ArmPivo/Arm.rotation
		currentMovement = movement.disabled
		velocity.y = 0.0
		velocity.x = 0.0

func disabled():
	if not grapplingHook:
		gravityModifier = gravityVarDownwards
		currentMovement = movement.enabled
		
	#if Input.is_action_just_released("GrapplingHook") and not movement.grappling:
		#grapplingHook.grappleDirection = -1
		#currentMovement = movement.enabled
		#gravityModifier = gravityVarDownwards
		#velocity.y = 0
		
func _physics_process(delta):
	getInput()
	velocity.y += GRAVITY * delta * gravityModifier

	match currentMovement:
		movement.disabled:
			disabled()
		movement.enabled:
			enabled()
		movement.jumping:
			jumping()
		movement.mantling:
			mantling()
		movement.grappling:
			grappling()
		movement.hanging:
			pass
		movement.dashing:
			pass
		movement.dying:
			pass
	
	move_and_slide()

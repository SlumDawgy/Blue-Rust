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

var gravityVarUpwards : float = 0.45
var gravityVarDownwards : float = 0.65

var coyoteTime : float = 0.01

# Mantle
@onready var mantleChecker : MantleCheckerComponent = $MantleCheckerComponent
var canMantle : bool = true

# Grappling
var grapplingHookScene : PackedScene = preload(GlobalPaths.GRAPPLING_HOOK_PATH)


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
	velocity.x = speed * inputDirection
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		currentMovement = movement.jumping
		jumped = true
		
	if Input.is_action_just_pressed("GrapplingHook"):
		currentMovement = movement.grappling
	
	if not is_on_floor() and velocity.y >= 0:
		currentMovement = movement.jumping

func jumping(delta):
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y = 0

	velocity.x = speed * inputDirection
	if jumped == true:
		velocity.y = jumpSpeed
		jumped = false

	#Gravity
	if not is_on_floor() and velocity.y < 0:
		velocity.y += delta * GRAVITY * gravityVarUpwards
	elif not is_on_floor() and velocity.y >= 0:
		velocity.y += delta * GRAVITY * gravityVarDownwards
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

func grappling():
	#velocity.y = GRAVITY * delta * 1.5
	var grapplingHook = grapplingHookScene.instantiate()
	owner.add_child(grapplingHook)
	grapplingHook.transform = $PlayerSprite/ArmPivo/Arm/GrappleOrigin.get_global_transform()
	# Position where the bullet is fired
	grapplingHook.rotation = $PlayerSprite/ArmPivo/Arm.rotation
	
	currentMovement = movement.enabled
	#grapplingHook.start(fire_direction)  # Set the direction if needed
	#parent_node.add_child(grapplingHook)  # Add bullet to the scene


func _physics_process(delta):
	getInput()
	$PlayerSprite/ArmPivo/Arm.look_at(get_global_mouse_position())
	match currentMovement:
		movement.disabled:
			pass
		movement.enabled:
			enabled()
		movement.jumping:
			jumping(delta)
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

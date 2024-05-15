extends CharacterBody2D
class_name Player

@onready var audio : Node = $Audios

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
@onready var grappleOrigin : Node2D = $PlayerSprite/Arm/GrappleOrigin

# HangingJump
var hangJumped : bool = false
var cursorXcoord : float

# Dash
var dashed : bool = false
@export var dashEnabled : bool = false
@export var dashSpeed : float = 250.0
@export var dashTime : float = 0.5
@onready var dashUpgrade : Node2D = $DashUpgrade

# Inputs
var inputDirection : float = 0.0
var inputJump : bool = false

# Health
@onready var health : HealthComponent = $HealthComponent
var _takingDamage: bool = false

enum movement
{
	disabled,
	enabled,
	jumping,
	mantling,
	grappling,
	hanging,
	hangingJump,
	dashing,
	takingDamage,
	dying
}

func _ready():
	currentMovement = movement.enabled

func getInput():
	inputDirection = Input.get_axis("MoveLeft", "MoveRight")

func disabled():
	velocity.x = move_toward(0,0,0)

func enabled():
	$PlayerSprite/Arm.look_at(get_global_mouse_position())
	
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
		
	if not is_on_floor() :
		currentMovement = movement.jumping
		return

func jumping():
	velocity.x = speed * inputDirection
	if jumped == true:
		velocity.y = jumpSpeed
		audio.playrandom(audio.playerJump, audio.playerJump_w_Grunt)
		jumped = false
	
	if Input.is_action_just_pressed("GrapplingHook"):
		gravityModifier = gravityVarGrapple
		currentMovement = movement.grappling
		return
	
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		gravityModifier = gravityVarDownwards
		velocity.y = 0
		return
	
	canMantle = true
	if not is_on_floor() and velocity.y >= 0:
		gravityModifier = gravityVarDownwards
		if canMantle == true:
			mantleChecker.process_mode = Node.PROCESS_MODE_INHERIT
		return
	
	if is_on_floor() and velocity.y >= 0:
		audio.playrandom(audio.playerLanding, audio.playerLanding_w_Grunt)
		currentMovement = movement.enabled

func mantling():
	if velocity.y != 0:
		velocity.y = 0
	if Input.is_action_just_pressed("Crouch"):
		canMantle = false
		currentMovement = movement.jumping
		mantleChecker.process_mode = Node.PROCESS_MODE_DISABLED
	if Input.is_action_just_pressed("Jump"):
		jumped = true
		currentMovement = movement.jumping
		canMantle = true

func grappling():
	if not grapplingHook:
		AudioManager.play_sound(audio.grappleShoot)
		grapplingHook = grapplingHookScene.instantiate()
		grapplingHook.startingPointNode = grappleOrigin
		grapplingHook.transform = grappleOrigin.get_global_transform()
		if get_tree().get_first_node_in_group("AimAssist") != null:
			grapplingHook.positionToReach = get_tree().get_first_node_in_group("AimAssist").position
		else:
			grapplingHook.positionToReach = get_global_mouse_position()
		grapplingHook.player = self
		
		owner.add_child(grapplingHook)
		
		velocity.y = 0.0
		velocity.x = 0.0

func hanging():
	velocity.y = move_toward(0,0,0)
	if Input.is_action_just_pressed("Jump"):
		audio.playrandom(audio.playerJump, audio.playerJump_w_Grunt)
		currentMovement = movement.hangingJump
		hangJumped = true
	
	if Input.is_action_just_released("GrapplingHook"):
		currentMovement = movement.jumping
		gravityModifier = gravityVarDownwards

func hangingJump():
	if Input.is_action_just_pressed("GrapplingHook"):
		gravityModifier = gravityVarGrapple
		currentMovement = movement.grappling
		return
	
	if hangJumped:
		velocity.y = -200
		hangJumped = false
		cursorXcoord = (to_local(position) - get_local_mouse_position()).x
	gravityModifier = gravityVarDownwards
	if cursorXcoord <= 0:
		velocity.x = 200
	else:
		velocity.x = -200
	if is_on_floor():
		audio.playrandom(audio.playerLanding, audio.playerLanding_w_Grunt)
		currentMovement = movement.enabled

func dashing():
	#dashEnabled = true
	if dashed and dashEnabled:
		velocity.y = 0
		if cursorXcoord <= 0:
			velocity.x = dashSpeed
		else:
			velocity.x = -dashSpeed
	
	
func takingDamage():
	if !_takingDamage:
		AudioManager.play_sound(audio.hurt)
		_takingDamage = true
	await get_tree().create_timer(1.0).timeout
	currentMovement = movement.enabled
	_takingDamage = false
	gravityModifier = gravityVarDownwards

func dying():
	velocity.x = move_toward(0,0,0)


func _physics_process(delta):
	if Input.is_action_just_pressed("changeDifficulty"):
		currentMovement = movement.dying
	
	getInput()
	
	if not is_on_floor():
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
			hanging()
		movement.hangingJump:
			hangingJump()
		movement.dashing:
			dashing()
		movement.takingDamage:
			takingDamage()
		movement.dying:
			dying()
	
	move_and_slide()


	

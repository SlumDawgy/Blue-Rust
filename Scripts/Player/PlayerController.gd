extends CharacterBody2D
class_name Player

# Movements
var currentMovement : int
@export var speed : float = 115.0

# Jump Variables
@export var jumpSpeed : float = -300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var coyoteTime : float = 0.01
var gravityVar : float = 0.75

# Inputs
var inputDirection : int = 0
var inputJump : bool = false

enum movement
{
	idle,
	running,
	jumping,
	falling,
	grappling,
	hanging,
	mantling,
	dashing,
	dying
}
	

# Called when the node enters the scene tree for the first time.
func _ready():
	currentMovement = 1
	pass # Replace with function body.

func getInput():
	inputDirection = Input.get_axis("MoveLeft", "MoveRight")
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		currentMovement = 2
	elif Input.is_action_just_released("Jump"):
		if currentMovement == 2:
			currentMovement = 3

func running():
	velocity.x = speed * inputDirection

func jumping():
	# Movement while jumping
	velocity.x = speed * inputDirection
	velocity.y = jumpSpeed

func falling():
	velocity.x = speed * inputDirection
	
	if is_on_floor():
		currentMovement = 1


func _physics_process(delta):
	getInput()
	
	if not is_on_floor():
		velocity.y += delta * gravity * gravityVar

	match currentMovement:
		movement.idle:
			pass
		movement.running:
			running()
		movement.jumping:
			jumping()
		movement.falling:
			falling()
		movement.grappling:
			pass
		movement.hanging:
			pass
		movement.mantling:
			pass
		movement.dashing:
			pass
		movement.dying:
			pass
	
	move_and_slide()

extends CharacterBody2D

var initialPosition : Vector2

@onready var animation = $Sprite

@onready var playerDetector = $PlayerDetector
var player : Player

@onready var wanderStartTimer = $WanderTimer
@export var wanderMinTime : float = 1.0
@export var wanderMaxTime : float = 3.0

@export var wanderMinDistance : float
@export var wanderMaxDistance : float
var wanderX : float
var wanderLocation : Vector2

var direction : int = 0
@export var speed : float = 25.0

var currentMovement : movement

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


enum movement
{
	disabled,
	enabled,
	moving,
	running,
	attacking,
	takingDamage,
	dying
}
func _ready():
	initialPosition = position
	currentMovement = movement.enabled
	randomize()
	
func enabled():
	if wanderStartTimer.is_stopped():
		wanderStartTimer.start(randf_range(wanderMinTime, wanderMaxTime))

func moving(delta):
	if direction == 1 and position.x < wanderLocation.x:
		velocity.x = speed * direction
	elif direction == -1 and position.x > wanderLocation.x:
		velocity.x = speed * direction
	else:
		velocity.x = 0
		currentMovement = movement.enabled

func running(delta):
	if animation.frame == 2 or animation.frame == 3 or animation.frame == 7 or animation.frame == 8:
		velocity.x = lerp(velocity.x, 0.0, 0.5)
	else:
		velocity.x = lerp(velocity.x, speed * direction * 3, 0.5)
	
	if global_position.x - player.global_position.x < 0:
		direction = 1
	else:
		direction = -1
	
	if abs(global_position.x - player.global_position.x) > 196:
		velocity.x = move_toward(0,0,0)
		currentMovement = movement.enabled

func attacking(delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if playerDetector.is_colliding():
		player = playerDetector.get_collider(0)
		currentMovement = movement.running
	
	if !is_on_floor():
		velocity.y += gravity * delta

	match currentMovement:
		movement.disabled:
			pass
		movement.enabled:
			enabled()
		movement.moving:
			moving(delta)
		movement.running:
			running(delta)
		movement.attacking:
			attacking(delta)
		movement.takingDamage:
			pass
		movement.dying:
			pass
	
	move_and_slide()


func _on_wander_timer_timeout():
	wanderX = randf_range(wanderMinDistance, wanderMaxDistance)
	wanderLocation = initialPosition + Vector2(wanderX, 0)
	if position.x > wanderLocation.x:
		direction = -1
	elif position.x < wanderLocation.x:
		direction = 1
	currentMovement = movement.moving


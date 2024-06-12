extends CharacterBody2D

var initialPosition : Vector2

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	print(wanderStartTimer.time_left)
	
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
			pass
		movement.attacking:
			pass
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


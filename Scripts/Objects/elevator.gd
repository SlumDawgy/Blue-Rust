extends AnimatedSprite2D

@onready var rayCast = $RayCast2D

@onready var elevatorBG = $ElevatorBG

var player
var canActivate = false

@export var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canActivate == true and Input.is_action_just_pressed("useItem"):
		player.currentMovement = player.movement.disabled
		elevatorBG.play("Activate")
		play("ElevatorClose")
		player.get_node("PlayerSprite").play("right_idle")
		await animation_finished
		elevatorBG.play("Activated")
		play("ElevatorMove")
	
	if animation == "ElevatorMove":
		position.y += -50 * delta * direction
	

func _on_player_check_body_entered(body : Player):
	player = body
	canActivate = true
	pass # Replace with function body.


func _on_player_check_body_exited(body : Player):
	canActivate = false
	pass # Replace with function body.

extends AnimatedSprite2D

@onready var elevatorBG = $ElevatorBG
@onready var audios = $Audios
@onready var raycastUp = $RayCastUp
@onready var raycastDown = $RayCastDown

var player : Player
var canActivate : bool = false

@export var direction = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canActivate == true and Input.is_action_just_pressed("useItem"):
		player.currentMovement = player.movement.disabled
		elevatorBG.play("Activate")
		play("ElevatorClose")
		AudioManager.play_sound(audios.close)
		player.get_node("PlayerSprite").play("right_idle")
		await animation_finished
		elevatorBG.play("Activated")
		play("ElevatorMove")
	
	if animation == "ElevatorMove":
		position.y += -50 * delta * direction
		
		if raycastUp.is_colliding() and direction == 1:
			elevatorBG.play("Activate")
			play("ElevatorOpen")
			await frame_changed
			AudioManager.play_sound(audios.open)
			await animation_finished
			elevatorBG.play("Inactive")
			player.currentMovement = player.movement.enabled
			direction *= -1
		
		elif raycastDown.is_colliding() and direction == -1:
			elevatorBG.play("Activate")
			play("ElevatorOpen")
			await frame_changed
			AudioManager.play_sound(audios.open)
			await animation_finished
			elevatorBG.play("Inactive")
			player.currentMovement = player.movement.enabled
			direction *= -1
	

func _on_player_check_body_entered(body : CharacterBody2D):
	if body is Player:
		player = body
		canActivate = true


func _on_player_check_body_exited(_body : Player):
	canActivate = false

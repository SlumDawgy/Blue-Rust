extends Node2D

@export var dashSound : AudioStream

@onready var player : Player = owner
@onready var dashTimer : Timer = $DashTimer
@onready var afterImageParticles : CPUParticles2D = $AfterimageParticles
@onready var dashStartParticles : CPUParticles2D = $DashStartParticles
@onready var dashParticles : CPUParticles2D = $DashParticles

@onready var animation : Animations = $"../PlayerSprite"

var canDash : bool = true
var dashDirection : int = 0

func _input(event):
	if event.is_action_pressed("Dash") and canDash and player.dashEnabled and !player.inWater:
		AudioManager.play_sound(player.audio.dash)
		addAfterimage()
		handleDashParticles()
		player.currentMovement = player.movement.dashing
		player.dashed = true
		player.cursorXcoord = (player.to_global(position) - get_global_mouse_position()).x
		canDash = false
		dashTimer.start(player.dashTime)
		

func _on_dash_timer_timeout():
	if player.dashed:
		player.dashed = false
		dashParticles.emitting = false
		player.currentMovement = player.movement.jumping
	
	if canDash == false and (player.currentMovement == player.movement.enabled or player.currentMovement == player.movement.mantling):
		canDash = true


func addAfterimage():
	if (get_local_mouse_position() - to_local(position)).x > 0 and dashDirection == 0:
		dashDirection = 1
	elif  dashDirection == 0:
		dashDirection = -1
	
	afterImageParticles.texture = animation.sprite_frames.get_frame_texture(animation.animation, animation.frame)
	if afterImageParticles.emitting == false :
			afterImageParticles.gravity.x = dashDirection * 200
			afterImageParticles.emitting = true
	
	
func handleDashParticles():
	if dashStartParticles.emitting == false :
		dashStartParticles.direction.x = dashDirection
		dashStartParticles.gravity.x = dashStartParticles.direction.x * 200
		dashStartParticles.emitting = true
	
	dashParticles.emitting = true

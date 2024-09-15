extends TextureRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#func _on_ready():
	#fade_in()

func fade_in():
	animation_player.play("FadeIn")
	#if animation_player.is_playing():
	#	GlobalReferences.player.currentMovement = GlobalReferences.player.movement.disabled
	#elif animation_player.animation_finished :
	#	GlobalReferences.player.currentMovement = GlobalReferences.player.movement.enabled


func fade_out():
	animation_player.play("FadeOut")
	#if animation_player.is_playing():
	#	GlobalReferences.player.currentMovement = GlobalReferences.player.movement.disabled
	#elif animation_player.animation_finished :
	#	GlobalReferences.player.currentMovement = GlobalReferences.player.movement.enabled

func reset():
	animation_player.play("RESET")
	await animation_player.animation_finished

extends TextureRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#func _on_ready():
	#fade_in()

func fade_in():
	animation_player.play("FadeIn")

func fade_out():
	animation_player.play("FadeOut")

func reset():
	animation_player.play("RESET")
	await animation_player.animation_finished

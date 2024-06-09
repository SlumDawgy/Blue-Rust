extends CanvasLayer

signal transitioned

func _ready():
	fadetonormal()

func fadetonormal():
	$AnimationPlayer.play("Fade_To_Normal")

func transition():
	$AnimationPlayer.play("Fade_To_Black")

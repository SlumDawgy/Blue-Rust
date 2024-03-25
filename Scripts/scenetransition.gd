extends CanvasLayer

signal transitioned

func _ready():
	fadetonormal()

func fadetonormal():
	$AnimationPlayer.play("Fade_To_Normal")

func transition():
	$AnimationPlayer.play("Fade_To_Black")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Fade_To_Black":
		emit_signal("transitioned")
		get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")

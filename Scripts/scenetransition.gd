extends CanvasLayer

signal transitioned

var faded := false

func _ready():
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
	Dialogic.start("res://Dialogic/Timelines/Prison1-1.dtl")
	$"../Player".staticActive = true

func _process(delta):
	if Dialogic.VAR.NextText == true and faded == false:
		fadetonormal()
		faded = true
		Dialogic.VAR.NextText = false
		Dialogic.start("res://Dialogic/Timelines/Prison1-2.dtl")
		$"../AudioStreamPlayer".play()
	elif Dialogic.VAR.NextTextD == true:
		$"../Player".staticActive = false
		$"../Player".moveActive = true
		Dialogic.VAR.NextTextD = false

func fadetonormal():
	$AnimationPlayer.play("Fade_To_Normal")

func transition():
	$AnimationPlayer.play("Fade_To_Black")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Fade_To_Black":
		emit_signal("transitioned")
		get_tree().change_scene_to_file(GlobalPaths.PRISON_SCENE_PATH)

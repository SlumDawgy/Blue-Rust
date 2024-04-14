extends CanvasLayer

signal transitioned

var faded := false
var player : CharacterBody2D

var start := false

var fall := false
var savePoint := false
var dream1 := false

func _ready():
	var currentSceneName = get_tree().get_current_scene().name
	if "Node2D" in currentSceneName:
		Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
		
		player = $"../Player"
		
		if start == false:
			Dialogic.start("res://Dialogic/Timelines/Prison1-1.dtl")
		else:
			fadetonormal()
			$"../AudioStreamPlayer".play()

func _process(_delta):
	if is_instance_valid(player) and start == false:
		player.staticActive = true
		start = true
	elif start == true:
		if Dialogic.VAR.Dialogue1 == true and faded == false:
			fadetonormal()
			$"../AudioStreamPlayer".play()
			faded = true
			Dialogic.VAR.Dialogue1 = false
		elif Dialogic.VAR.Dialogue2 == true:
			$"../Player".staticActive = false
			$"../Player".moveActive = true
			Dialogic.VAR.Dialogue2 = false
		elif Dialogic.VAR.Dialogue3 == true:
			$"../Player".staticActive = false
			$"../Player".moveActive = true
			Dialogic.VAR.Dialogue3 = false
		elif Dialogic.VAR.Dialogue4 == true:
			$"../Player".staticActive = false
			$"../Player".moveActive = true
			Dialogic.VAR.Dialogue4 = false
		elif Dialogic.VAR.Dialogue5 == true:
			Dialogic.VAR.Dialogue5 = false
			get_tree().root.get_node("Node2D").process_mode = Node.PROCESS_MODE_DISABLED
			get_tree().root.get_node("Node2D").visible = false
			var newScene = load("res://Scenes/Levels/DreamSequences/DashDreamSequence.tscn")
			var instanceNewScene = newScene.instantiate()
			get_tree().root.add_child(instanceNewScene)
			

func fadetonormal():
	$AnimationPlayer.play("Fade_To_Normal")

func transition():
	$AnimationPlayer.play("Fade_To_Black")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Fade_To_Black":
		emit_signal("transitioned")
		get_tree().change_scene_to_file(GlobalPaths.PRISON_SCENE_PATH)

func _Dialogue3(body):
	if body.is_in_group("Player") and fall == false:
		body.staticActive = true
		fall = true
		Dialogic.start("res://Dialogic/Timelines/Prison1-3.dtl")
	pass # Replace with function body.

func _Dialogue4(body):
	if body.is_in_group("Player") and savePoint == false:
		body.staticActive = true
		savePoint = true
		Dialogic.start("res://Dialogic/Timelines/Prison1-4.dtl")
	pass # Replace with function body.

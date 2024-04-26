extends CanvasLayer

signal transitioned

var faded := true
@export var player : Player

var start := true

var fall := true
var savePoint := true
var dream1 := false

func _ready():
	var currentSceneName = get_tree().get_current_scene().name
	if "Prison" in currentSceneName:
		Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
		
		if start == false:
			Dialogic.start("res://Dialogic/Timelines/Prison1-1.dtl")
		else:
			fadetonormal()
			get_tree().get_current_scene().get_node("Audio/MainLevelTheme").play()

func _process(_delta):
	if is_instance_valid(player) and start == false:
		player.currentMovement = player.FirstBoss.movement.disabled
		start = true
	elif start == true:
		if Dialogic.VAR.Dialogue1 == true and faded == false:
			fadetonormal()
			player.get_node("PlayerSprite").play("getting_up")
			get_tree().get_current_scene().get_node("Audio/MainLevelTheme").play()
			faded = true
			Dialogic.VAR.Dialogue1 = false
		elif Dialogic.VAR.Dialogue2 == true:
			player.currentMovement = player.FirstBoss.movement.enabled
			Dialogic.VAR.Dialogue2 = false
		elif Dialogic.VAR.Dialogue3 == true:
			player.currentMovement = player.FirstBoss.movement.enabled
			Dialogic.VAR.Dialogue3 = false
		elif Dialogic.VAR.Dialogue4 == true:
			player.currentMovement = player.FirstBoss.movement.enabled
			Dialogic.VAR.Dialogue4 = false
		elif Dialogic.VAR.Dialogue5 == true:
			Dialogic.VAR.Dialogue5 = false
			get_tree().root.get_node("Prison").process_mode = Node.PROCESS_MODE_DISABLED
			get_tree().root.get_node("Prison").visible = false
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

func _Dialogue3(body : Player):
	if fall == false:
		body.currentMovement = body.FirstBoss.movement.disabled
		fall = true
		Dialogic.start("res://Dialogic/Timelines/Prison1-3.dtl")
	pass # Replace with function body.

func _Dialogue4(body : Player):
	if savePoint == false:
		body.currentMovement = body.FirstBoss.movement.disabled
		savePoint = true
		Dialogic.start("res://Dialogic/Timelines/Prison1-4.dtl")
	pass # Replace with function body.

extends CanvasLayer

signal transitioned

var faded := true
@export var player : Player

var start := true

var fall := true
var savePoint := true
var dream1 := false

var loading : bool = false

func _ready():
	fadetonormal()
	if GlobalPaths.LOADING == true and is_instance_valid(player):
		loaded()
		GlobalPaths.LOADING = false

func fadetonormal():
	$AnimationPlayer.play("Fade_To_Normal")

func transition():
	$AnimationPlayer.play("Fade_To_Black")


func _on_animation_player_animation_finished(anim_name):
	var currentSceneName = get_tree().get_current_scene().name
	if anim_name == "Fade_To_Black" and currentSceneName == "MainMenu":
		emit_signal("transitioned")
		if loading == true:
			GlobalPaths.LOADING = true
		get_tree().change_scene_to_file(GlobalPaths.PRISON_SCENE_PATH)

func loaded():
	player.position.x = int(SaveSystem.get_var("player:positionX"))
	player.position.y = int(SaveSystem.get_var("player:positionY"))
	player.doubleJumpEnabled = bool(SaveSystem.get_var("player:doubleJump"))
	player.dashEnabled = bool(SaveSystem.get_var("player:dash"))
	player.parasolEnabled = bool(SaveSystem.get_var("player:parasol"))
	
	Dialogues.Prison1_1 = bool(SaveSystem.get_var("Dialogues:Prison1_1"))
	Dialogues.Prison1_2 = bool(SaveSystem.get_var("Dialogues:Prison1_2"))
	Dialogues.Prison1_3 = bool(SaveSystem.get_var("Dialogues:Prison1_3"))
	Dialogues.Prison1_4 = bool(SaveSystem.get_var("Dialogues:Prison1_4"))

extends Node2D
@export var player : Player
@export var boss : Enemy

var flagPrison1_1 : bool = true
var flagPrison1_2 : bool = true
var flagPrison1_3 : bool = true
var flagPrison1_4 : bool = true
var prisonStartRoom: bool = false

@export var level_bgm = preload("res://Assets/Sounds/Music/Symbol.WAV") 
@onready var boss_BGM = preload("res://Assets/Sounds/Music/Mechanical (2).WAV")


func _ready():
	
	player = GlobalReferences.player
	
	if Dialogues.Prison1_1:
		flagPrison1_1 = false
	if Dialogues.Prison1_2:
		flagPrison1_2 = false
	if Dialogues.Prison1_3:
		flagPrison1_3 = false
	if Dialogues.Prison1_4:
		flagPrison1_4 = false
	
	if get_tree().get_current_scene().name == "Prison_Start" :
		prisonStartRoom = true
	if level_bgm != null:
		AudioManager.play_Music(level_bgm)
	if Dialogues.Prison1_1 == false:
		if prisonStartRoom :
			player.currentMovement = player.movement.disabled
			player.get_node("PlayerSprite").play("getting_up")
			player.get_node("PlayerSprite").set_speed_scale(0)
			Dialogic.start("res://Dialogic/Timelines/Prison1-1.dtl")
		else :
			Dialogues.Prison1_1 = true
			player.currentMovement = player.movement.enabled
		
func PowerUp(body):
	if body.name == "HitBoxComponent":
		player.get_node("PlayerSprite").playAnimation("idle")
		player.currentMovement = player.movement.disabled
		player.dashEnabled = true
		get_tree().root.get_node("Prison").get_node("powerUp").queue_free()
		Dialogic.start("res://Dialogic/Timelines/Prison1-4.dtl")

func _process(_delta):
	if  Dialogues.Prison1_1 == false:
		if Dialogic.VAR.WakeUp:
			Dialogic.VAR.WakeUp = false
			player.get_node("PlayerSprite").set_speed_scale(2)
	if Dialogues.Prison1_1 and flagPrison1_1:
		player.get_node("PlayerSprite").play("right_idle")
		player.currentMovement = player.movement.enabled
		#$ControlLabels/MoveLabel.visible = true
		flagPrison1_1 = false
	if Dialogues.Prison1_2 and flagPrison1_2:
		player.currentMovement = player.movement.enabled
		flagPrison1_2 = false
	if Dialogues.Prison1_3 and flagPrison1_3:
		player.currentMovement = player.movement.enabled
		flagPrison1_3 = false
	if Dialogues.Prison1_4 and flagPrison1_4:
		player.get_node("PlayerSprite").play("death")
		if player.get_node("PlayerSprite").is_playing() == false:
			get_tree().root.get_node("Prison").process_mode = Node.PROCESS_MODE_DISABLED
			get_tree().root.get_node("Prison").visible = false
			flagPrison1_4 = false
			get_tree().root.get_node("Prison").queue_free()
			var DreamScene = load(GlobalPaths.DREAM_SCENE_PATH)
			var instanceDreamScene = DreamScene.instantiate()
			get_tree().root.add_child(instanceDreamScene)

func _on_dialogue_12_body_entered(body):
	if body.name == "Player" and flagPrison1_2:
		AudioManager.play_sound(player.audio.grappleShoot)
		body.get_node("PlayerSprite").playAnimation("idle")
		body.currentMovement = body.movement.disabled
		Dialogic.start("res://Dialogic/Timelines/Prison1-2.dtl")
		$"Cutscenes/dialogue1-2".queue_free()

func _on_dialogue_13_body_entered(body):
	if body.name == "Player" and flagPrison1_3:
		body.get_node("PlayerSprite").playAnimation("idle")
		body.currentMovement = body.movement.disabled
		Dialogic.start("res://Dialogic/Timelines/Prison1-3.dtl")
		$"Cutscenes/dialogue1-3".queue_free()

func _on_start_boss_body_entered(body):
	if body.name == "Player":		
		AudioManager.play_Music(boss_BGM)
		$"Cutscenes/Start_Boss".PROCESS_MODE_DISABLED
		$Boss/First_Boss.currentMovement = $Boss/First_Boss.movement.enabled

func _on_move_label_area_2d_body_exited(body):
	if body.name == "Player":
		$ControlLabels/MoveLabel.queue_free()

func _on_jump_label_area_2d_body_entered(body):
	if body.name == "Player":
		$ControlLabels/JumpLabel.visible = true

func _on_jump_label_area_2d_body_exited(body):
	if body.name == "Player":
		$ControlLabels/JumpLabel.visible = false

func _on_grapple_label_area_2d_body_entered(body):
	if body.name == "Player":
		$ControlLabels/GrappleLabel.visible = true

func _on_grapple_label_area_2d_body_exited(body):
	if body.name == "Player":
		$ControlLabels/GrappleLabel.visible = false

func _on_hang_jump_area_2d_body_entered(body):
	if body.name == "Player":
		$ControlLabels/HangJumpLabel.visible = true

func _on_hang_jump_area_2d_body_exited(body):
	if body.name == "Player":
		$ControlLabels/HangJumpLabel.visible = false

func _on_save_point_body_entered(body):
	pass

func _on_save_point_body_exited(body):
	pass

func _on_save_point_2_body_entered(body):
	if body.name == "Player":
		$SavePoints.canSave = true
		$"SavePoints/Save Point2/Label".visible = true

func _on_save_point_2_body_exited(body):
	if body.name == "Player":
		$SavePoints.canSave = false
		$"SavePoints/Save Point2/Label".visible = false
		$"SavePoints/Save Point2/Label".set_text("PRESS E TO SAVE THE GAME")

func _on_save_point_3_body_entered(body):
	if body.name == "Player":
		$SavePoints.canSave = true
		$"SavePoints/Save Point3/Label".visible = true

func _on_save_point_3_body_exited(body):
	if body.name == "Player":
		$SavePoints.canSave = false
		$"SavePoints/Save Point3/Label".visible = false
		$"SavePoints/Save Point3/Label".set_text("PRESS E TO SAVE THE GAME")

extends Node2D
@export var player : Player
@export var boss : Enemy
var dialogueFlag1 : bool = true
var dialogueFlag2 : bool = true
var dialogueFlag3 : bool = true
var dialogueFlag4 : bool = true
var dialogueFlag5 : bool = true

func _ready():
	get_tree().get_current_scene().get_node("Audio/MainLevelTheme").play()
	if FileAccess.file_exists("user://savegame.save"):
		load_game()
	else:
		player.currentMovement = player.movement.disabled
		player.get_node("PlayerSprite").play("getting_up")
		player.get_node("PlayerSprite").set_speed_scale(0)
		Dialogic.start("res://Dialogic/Timelines/Prison1-1.dtl")

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		print("Nothing to load!")
		return
	else:
		Dialogic.VAR.WakeUp = false
		Dialogic.VAR.Dialogue1 = true
		Dialogic.VAR.Dialogue2 = true
		Dialogic.VAR.Dialogue3 = true
		dialogueFlag1 = false
		dialogueFlag2 = false
		dialogueFlag3 = false

		var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
		while save_game.get_position() < save_game.get_length():
			var json_string = save_game.get_line()

			# Creates the helper class to interact with JSON
			var json = JSON.new()

			# Check if there is any error while parsing the JSON string, skip in case of failure
			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				continue

			# Get the data from the JSON object
			var node_data = json.get_data()
			player.position.x = node_data["player_position"]["x"]
			player.position.y = node_data["player_position"]["y"]
			player.currentMovement = player.movement.enabled
			player.health.health = player.health.maxHealth
			$"Audio/BossFight".playing = false
			$"Audio/MainLevelTheme".playing = true
			boss.currentMovement = boss.movement.starting
			boss.get_node("HealthComponent").health = boss.get_node("HealthComponent").maxHealth
			#$"Cutscenes/Start_Boss".PROCESS_MODE_PAUSABLE

			
func PowerUp(body):
	if body.name == "HitBoxComponent":
		player.get_node("PlayerSprite").playAnimation("idle")
		player.currentMovement = player.movement.disabled
		player.dashEnabled = true
		get_tree().root.get_node("Prison").get_node("powerUp").queue_free()
		Dialogic.start("res://Dialogic/Timelines/Prison1-4.dtl")

func _process(_delta):
	if $SavePoints.canSave and Input.is_action_just_pressed("useItem"):
		$SavePoints.save_game()
		player.health.health = player.health.maxHealth
		$"SavePoints/Save Point/Label".set_text("SAVED!")
		$"SavePoints/Save Point2/Label".set_text("SAVED!")
		$"SavePoints/Save Point3/Label".set_text("SAVED!")
		
	if Dialogic.VAR.WakeUp:
		Dialogic.VAR.WakeUp = false
		player.get_node("PlayerSprite").set_speed_scale(2)
	if Dialogic.VAR.Dialogue1 and dialogueFlag1:
		player.get_node("PlayerSprite").play("right_idle")
		player.currentMovement = player.movement.enabled
		dialogueFlag1 = false
		$ControlLabels/MoveLabel.visible = true
	if Dialogic.VAR.Dialogue2 and dialogueFlag2:
		player.currentMovement = player.movement.enabled
		dialogueFlag2 = false
	if Dialogic.VAR.Dialogue3 and dialogueFlag3:
		player.currentMovement = player.movement.enabled
		dialogueFlag3 = false
	if Dialogic.VAR.Dialogue4 and dialogueFlag4:
		dialogueFlag4 = false
		player.get_node("PlayerSprite").play("death")
	if Dialogic.VAR.Dialogue4 and player.get_node("PlayerSprite").is_playing() == false:
		get_tree().root.get_node("Prison").process_mode = Node.PROCESS_MODE_DISABLED
		get_tree().root.get_node("Prison").visible = false
		get_tree().root.get_node("Prison").queue_free()
		var DreamScene = load(GlobalPaths.DREAM_SCENE_PATH)
		var instanceDreamScene = DreamScene.instantiate()
		get_tree().root.add_child(instanceDreamScene)

func _on_dialogue_12_body_entered(body):
	if body.name == "Player":
		AudioManager.play_sound(player.audio.grappleShoot)
		body.get_node("PlayerSprite").playAnimation("idle")
		body.currentMovement = body.movement.disabled
		Dialogic.start("res://Dialogic/Timelines/Prison1-2.dtl")
		$"Cutscenes/dialogue1-2".queue_free()

func _on_dialogue_13_body_entered(body):
	if body.name == "Player":
		body.get_node("PlayerSprite").playAnimation("idle")
		body.currentMovement = body.movement.disabled
		Dialogic.start("res://Dialogic/Timelines/Prison1-3.dtl")
		$"Cutscenes/dialogue1-3".queue_free()

func _on_start_boss_body_entered(body):
	if body.name == "Player":
		$"Audio/MainLevelTheme".playing = false
		$"Audio/BossFight".playing = true
		#$"Cutscenes/Start_Boss".PROCESS_MODE_DISABLED
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
	if body.name == "Player":
		$SavePoints.canSave = true
		$"SavePoints/Save Point/Label".visible = true

func _on_save_point_body_exited(body):
	if body.name == "Player":
		$SavePoints.canSave = false
		$"SavePoints/Save Point/Label".visible = false
		$"SavePoints/Save Point/Label".set_text("PRESS E TO SAVE THE GAME")

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

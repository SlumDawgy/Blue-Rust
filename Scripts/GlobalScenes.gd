extends Node

var loaded : bool = false
var locationID : int = 0

func _ready():
	pass

func loadingScene(sceneID : String, entranceID : int):
	locationID = entranceID

	match sceneID:
		"Main_Menu":
			get_tree().change_scene_to_file(GlobalPaths.MAIN_MENU_SCREEN_PATH)
		"Prison":
			get_tree().change_scene_to_file(GlobalPaths.PRISON_SCENE_PATH)
		"DashDream":
			get_tree().change_scene_to_file(GlobalPaths.DREAM_SCENE_PATH)
		"City":
			pass
		"ClockTower":
			pass
	
	get_tree().paused = false

func loadingPlayer(player : Player):
	player.position.x = int(SaveSystem.get_var("player:positionX"))
	player.position.y = int(SaveSystem.get_var("player:positionY"))
	player.doubleJumpEnabled = bool(SaveSystem.get_var("player:doubleJump"))
	player.dashEnabled = bool(SaveSystem.get_var("player:dash"))
	player.parasolEnabled = bool(SaveSystem.get_var("player:parasol"))

	Dialogues.Prison1_1 = bool(SaveSystem.get_var("Dialogues:Prison1_1"))
	Dialogues.Prison1_2 = bool(SaveSystem.get_var("Dialogues:Prison1_2"))
	Dialogues.Prison1_3 = bool(SaveSystem.get_var("Dialogues:Prison1_3"))
	Dialogues.Prison1_4 = bool(SaveSystem.get_var("Dialogues:Prison1_4"))

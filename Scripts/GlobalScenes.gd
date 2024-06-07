extends Node

func _ready():
	pass

func loadingScene(sceneID : int, entranceID : int):
	match sceneID:
		1:
			pass
		2:
			pass
		3:
			pass
		4:
			pass
		5:
			pass
		6:
			pass

func loadingGame():
	var player = get_tree().root.get_child(get_tree().root.get_child_count() - 1).find_child("Player")
	
	player.position.x = int(SaveSystem.get_var("player:positionX"))
	player.position.y = int(SaveSystem.get_var("player:positionY"))
	player.doubleJumpEnabled = bool(SaveSystem.get_var("player:doubleJump"))
	player.dashEnabled = bool(SaveSystem.get_var("player:dash"))
	player.parasolEnabled = bool(SaveSystem.get_var("player:parasol"))
	
	Dialogues.Prison1_1 = bool(SaveSystem.get_var("Dialogues:Prison1_1"))
	Dialogues.Prison1_2 = bool(SaveSystem.get_var("Dialogues:Prison1_2"))
	Dialogues.Prison1_3 = bool(SaveSystem.get_var("Dialogues:Prison1_3"))
	Dialogues.Prison1_4 = bool(SaveSystem.get_var("Dialogues:Prison1_4"))

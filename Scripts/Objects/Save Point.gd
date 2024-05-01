extends Node2D

var canSave = false
@export var player : Player

func save_game():
	var saveFile =  FileAccess.open("user://savegame.save", FileAccess.WRITE)

	var save_json = {
		"player_position": {"x": player.position.x, "y": player.position.y}
	}
	saveFile.store_string(JSON.stringify(save_json))
	saveFile.close()
	print("Game saved successfully!")
	player.health.health = player.health.maxHealth

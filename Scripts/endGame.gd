extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_body_entered(body):
	if body.is_in_group("Player"):
		if FileAccess.file_exists("user://savegame.save"):
			DirAccess.remove_absolute("user://savegame.save")
		get_tree().paused = true
		get_tree().change_scene_to_file("res://Scenes/endGame.tscn")
	pass # Replace with function body.

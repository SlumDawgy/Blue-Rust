extends Area2D

var canSave = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $AnimatedSprite2D.is_playing() == false:
		$AnimatedSprite2D.play("default")
	
	if canSave == true and Input.is_action_just_pressed("useItem"):
		save_game()
		$Label.set_text("SAVED!")
	pass


func _on_body_entered(body):
	if body.is_in_group("Player"):
		canSave = true
		$Label.visible = true
	
	pass # Replace with function body.


func _on_body_exited(body):
	if body.is_in_group("Player"):
		canSave = false
		$Label.visible = false
		$Label.set_text("PRESS E TO SAVE THE GAME")
	pass # Replace with function body.

func save_game():
	var save_game1 = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_game1.store_line(json_string)

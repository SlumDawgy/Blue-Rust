extends Node2D
@export var player : Player






# Called when the node enters the scene tree for the first time.
#func _ready():
	#if FileAccess.file_exists("user://savegame.save"):
		#load_game()
	#
	#
	#pass # Replace with function body.
	#
#func load_game():
	#if not FileAccess.file_exists("user://savegame.save"):
		#return # Error! We don't have a save to load.
#
	## We need to revert the game state so we're not cloning objects
	## during loading. This will vary wildly depending on the needs of a
	## project, so take care with this step.
	## For our example, we will accomplish this by deleting saveable objects.
	#var save_nodes = get_tree().get_nodes_in_group("Persist")
	#for i in save_nodes:
		#i.queue_free()
#
	## Load the file line by line and process that dictionary to restore
	## the object it represents.
	#var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	#while save_game.get_position() < save_game.get_length():
		#var json_string = save_game.get_line()
#
		## Creates the helper class to interact with JSON
		#var json = JSON.new()
#
		## Check if there is any error while parsing the JSON string, skip in case of failure
		#var parse_result = json.parse(json_string)
		#if not parse_result == OK:
			#print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			#continue
#
		## Get the data from the JSON object
		#var node_data = json.get_data()
#
		## Firstly, we need to create the object and add it to the tree and set its position.
		#var new_object = load(node_data["filename"]).instantiate()
		#get_node(node_data["parent"]).add_child(new_object)
		#new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
#
		## Now we set the remaining variables.
		#for i in node_data.keys():
			#if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				#continue
			#new_object.set(i, node_data[i])
#
func PowerUp(body):
	print('here', body)
	player.currentMovement = player.movement.disabled
	player.dashEnabled = true
	get_tree().root.get_node("Prison").get_node("powerUp").queue_free()
	Dialogic.start("res://Dialogic/Timelines/Prison1-5.dtl")


extends Node
class_name RoomContainer

@export var player: Player
@export var camera: Camera2D
@export var first_room: String
@export var first_room_entrance: String = "TransitionPoints/Transition_1"
@onready var transition_fader = $TransitionFadeout

var can_transition: bool = true
var transition_complete: bool = true
var first_load: bool = true

var current_room: String
var current_entrance: String 

func _ready():
	#if SaveSystem.get_var("savedScene") != null :
	#	first_room = SaveSystem.get_var("savedScene")
	load_room(first_room, first_room_entrance)

# Function to load a level
func load_room(room_path: String, room_entrance: String):
	current_room = room_path
	current_entrance = room_entrance
	
	# Defer the entire process to avoid modification during physics processing
	can_transition = false
#	for child in get_tree().root.get_children():
#		if child is Lantern:
#			if !child.held:
#				child.queue_free() 	# This is so that when you Move to a new room
#									# if you've set down the lanturn, it returns
#									# to the place where it originally spawned
	
	call_deferred("_deferred_load_room", room_path, room_entrance)

func _deferred_load_room(room_path: String, room_entrance: String):
	if !first_load:
		transition_fader.fade_out()
		await transition_fader.animation_player.animation_finished
	first_load = false
	
	# Clear the current level
	if get_child_count() > 0:
		queue_free_children()
	
	# Load the new level scene
	var new_level = load(GlobalPaths.get(room_path)).instantiate()

	# Add the new level to the LevelContainer
	add_child(new_level)

	# Get the target door in the new scene
	var target_entrances = new_level.get_node("TransitionPoints")
	var target_entrance = target_entrances.get_node(room_entrance)

	if target_entrance:
		player.global_position = target_entrance.global_position
		#player.state = player.STATE_IDLE
		
	var camera_bounds = new_level.get_node("CameraBounds/CameraBoundsShape")
	
	await camera.set_camera_bounds(camera_bounds)
	await get_tree().create_timer(0.5).timeout
	
	transition_fader.fade_in()
	can_transition = true


# Helper function to clear children
func queue_free_children():
	for child in get_children():
		if child != transition_fader:
			child.queue_free()


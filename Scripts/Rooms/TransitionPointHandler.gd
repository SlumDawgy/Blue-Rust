extends Area2D

@export var target_room: String
@export var target_room_entrance: String
@onready var camera_bounds = $"../../CameraBounds/CameraBoundsShape"

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body is Player:
		var room_container = get_tree().current_scene.get_node("RoomContainer")
		if room_container.can_transition:
			room_container.load_room(target_room, target_room_entrance)

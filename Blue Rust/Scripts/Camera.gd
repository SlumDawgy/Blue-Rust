extends Camera2D

var player

var speed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	
	position = to_local(player.position)
	speed = player.SPEED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.velocity.x == 0 and position.distance_to(player.position) < 1:
		pass
	elif global_position != player.global_position:
		if position.distance_to(player.position) < 30:
			position += (player.position - position).normalized() / 5
		else:
			position += (player.position - position).normalized()
	

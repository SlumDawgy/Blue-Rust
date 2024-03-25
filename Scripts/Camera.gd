extends Camera2D

var player

var speedX = 300
var speedY = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	
	position = to_local(player.position)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_instance_valid(player):
		player = get_tree().get_first_node_in_group("Player")
	elif is_instance_valid(player):
		if player.velocity.x > 0:
			position.x += speedX * delta
		elif player.velocity.x < 0:
			position.x -= speedX * delta
		position.x = clamp(position.x, player.position.x - 30, player.position.x + 30)

		if player.velocity.y > 0:
			position.y += speedY * delta
		elif player.velocity.y < 0:
			position.y -= speedY * delta
		position.y = clamp(position.y, player.position.y - 25, player.position.y + 25)

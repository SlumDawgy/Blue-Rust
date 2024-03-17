extends Camera2D

var player

var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	
	position = to_local(player.position)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.velocity.x > 0:
		position.x += speed * delta
	elif player.velocity.x < 0:
		position.x -= speed * delta
	position.x = clamp(position.x, player.position.x - 30, player.position.x + 30)

	if player.velocity.y > 0:
		position.y += speed * delta
	elif player.velocity.y < 0:
		position.y -= speed * delta
	position.y = clamp(position.y, player.position.y - 40, player.position.y + 40)
	
	if player.velocity.x == 0 and position.distance_to(player.position) > 1:
		position += (player.position - position).normalized() * delta * speed


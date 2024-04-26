extends Camera2D

@export var player : Player

var speedX = 300
var speedY = 200

	
func _process(delta):
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

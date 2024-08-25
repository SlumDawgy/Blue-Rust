extends Camera2D

@export var player : Player

var speedX = 300
var speedY = 200
var _zoom : Vector2 = Vector2(3,3)



func _ready():
	player = GlobalReferences.player
	GlobalReferences.camera = self
	position = player.global_position
	handle_camerea_zoom(_zoom)

func _process(delta):
	if position == player.global_position and position_smoothing_enabled == false:
		position_smoothing_enabled = true
	
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


func set_camera_bounds(camera_bounds):
	limit_bottom = camera_bounds.position.y + camera_bounds.shape.size.y/2.
	limit_top = camera_bounds.position.y - camera_bounds.shape.size.y/2.
	limit_left = camera_bounds.position.x - camera_bounds.shape.size.x/2.
	limit_right = camera_bounds.position.x + camera_bounds.shape.size.x/2.
	
	
func handle_camerea_zoom(new_zoom):
	zoom = new_zoom
# need to handle camera zoom, currently setting zoom to constant size in main camera

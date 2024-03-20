extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_body_entered(_body):
	var player = get_parent()
	
	if _body != player:
		player.jumping = false
		player.gravityVar = 1
		player.target_velocity.y = move_toward(0, player.target_velocity.y, player.SPEED)
	pass # Replace with function body.

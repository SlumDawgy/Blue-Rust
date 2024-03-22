extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_body_entered(_body):
	var player = get_parent()
	
	if _body != player:
		player.jumping = false
		player.gravityVar = 0.75
	pass # Replace with function body.

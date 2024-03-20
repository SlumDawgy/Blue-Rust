extends Area2D

var canReceive := false
var player 

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canReceive == true and Input.is_action_just_pressed("useItem"):
		player.dashUpgrade = true
		queue_free()
	pass


func _on_body_entered(body):
	if body.is_in_group("Player"):
		canReceive = true
	pass # Replace with function body.


func _on_body_exited(body):
	if body.is_in_group("Player"):
		canReceive = false
	pass # Replace with function body.

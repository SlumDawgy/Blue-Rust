extends Area2D

var positionToReach : Vector2
var isMoving = true


var player


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isMoving == true:
		position += positionToReach.normalized() * 2
	
	if isMoving == false:
		movePlayer(player.position)
	
	pass


func _on_body_entered(body):
	# Find Grapplable Object and move Player
	if body.is_in_group("Grapple"):
		isMoving = false
		player.isGrappling = true
	
	# Queue_free grapplingHook
	if body.is_in_group("Player") and isMoving == false:
		player.isGrappling = false
		queue_free()
	
	pass
	
	# Move player to grappling hook
func movePlayer(playerFirstPosition):
	player.position += (position - playerFirstPosition).normalized() * 2

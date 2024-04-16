extends Area2D
class_name Grapple

const speed : float = 100.0
const characterSpeed : float = 250.0

var startingPointNode : Node2D
var startPosition : Vector2
var positionToReach : Vector2
var returning : bool = false
var movingPlayer : bool = false
var player : Player

var audios
var canPlayRetrieve = true

func _ready():
	startPosition = position
	pass # Replace with function body.

func _physics_process(delta):
	if movingPlayer:
		player.position += (transform.origin - player.transform.origin).normalized() * speed * delta
		if position.distance_to(startingPointNode.get_global_transform().origin) < 8:
			if Input.is_action_pressed("GrapplingHook"):
				startHanging()
			else:
				player.currentMovement = player.movement.enabled
				queue_free()
	elif !returning:
		position += (positionToReach - startPosition).normalized() * speed * delta
	else:
		position += (startingPointNode.get_global_transform().get_origin() - position).normalized() * speed * delta
		
		if position.distance_to(startingPointNode.get_global_transform().origin) < 8:
			player.currentMovement = player.movement.enabled
			queue_free()
	
func _on_body_shape_entered(body_rid, body, _body_shape_index, _local_shape_index):
	if body.get_layer_for_body_rid(body_rid) == 1:
		var coords = body.get_coords_for_body_rid(body_rid)
		position = body.map_to_local(coords)
		movingPlayer = true
	
	elif body.get_layer_for_body_rid(body_rid) == 0:
		returning = true
		
func startHanging():
	player.currentMovement = player.movement.hanging
	player.position = position + Vector2(0, 24)
	queue_free()

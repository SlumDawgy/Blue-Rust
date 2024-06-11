extends Area2D
class_name Grapple

const speed : float = 250.0
const characterSpeed : float = 350.0
const maxGrappleDistance : int = 150

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

class BasicAttack:
	var damage : int = 1
	var knockback : int = 0
	var direction : int = 1
	var knockupwards : int = 0

func _physics_process(delta):
	if position.distance_to(player.get_global_transform().origin) > maxGrappleDistance:
		if !returning:
			AudioManager.play_sound(player.audio.grappleRetrieve)
		returning = true
		
	if movingPlayer:
		player.position += (transform.origin - player.transform.origin).normalized() * speed * delta
		if position.distance_to(player.get_global_transform().origin) < 16:
			if Input.is_action_pressed("GrapplingHook"):
				startHanging()
			else:
				player.currentMovement = player.movement.jumping
				player.gravityModifier = player.gravityVarDownwards
				queue_free()
	elif !returning:
		position += (positionToReach - startPosition).normalized() * speed * delta
	else:
		position += (startingPointNode.get_global_transform().get_origin() - position).normalized() * speed * delta
		
		if position.distance_to(startingPointNode.get_global_transform().origin) < 8:
			if player.is_on_floor():
				player.currentMovement = player.movement.enabled
			else:
				player.currentMovement = player.movement.jumping
			player.gravityModifier = player.gravityVarDownwards
			queue_free()
	
func _on_body_shape_entered(body_rid, body, _body_shape_index, _local_shape_index):
	if body.is_class("TileMap"):
		if body.get_layer_for_body_rid(body_rid) == 1:
			AudioManager.play_sound(player.audio.hookAttach)
			var coords = body.get_coords_for_body_rid(body_rid)
			position = body.map_to_local(coords)
			movingPlayer = true
		
		elif body.get_layer_for_body_rid(body_rid) == 0:
			if !returning:
				AudioManager.play_sound(player.audio.hookHitWall)
				AudioManager.play_sound(player.audio.grappleRetrieve)
			returning = true
				
func startHanging():
	player.currentMovement = player.movement.hanging
	player.position = position + Vector2(0, 24)
	queue_free()

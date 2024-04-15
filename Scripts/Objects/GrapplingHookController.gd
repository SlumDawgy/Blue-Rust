extends Area2D

var grappleSpeed : int = 400
var maxGrappleRange : int = 150
var minGrappleRange : int = 15

@onready var audio : Node2D = get_node("sfx")

var player : Player
var grappleDirection : int = 1
var grappling : bool = false

var coordsToMoveTowards : Vector2i

func _ready():
	player = get_parent().get_node("Player")
	connect("body_shape_entered", _on_body_shape_entered)

func _physics_process(delta):
	var distanceFromPlayer = position.distance_to(player.position)

	if distanceFromPlayer >= maxGrappleRange:
		grappleDirection = -1
	
	if distanceFromPlayer <= minGrappleRange and grappleDirection < 0:
		queue_free()
		
	if not grappling:
		position += transform.x * grappleSpeed * delta * grappleDirection
	else:
		if distanceFromPlayer >= 20:
			player.position += Vector2(coordsToMoveTowards)*delta
		else:
			player.position = position + Vector2(0, 20)
			grappling = false
			queue_free()

func _on_body_shape_entered(body_rid, body, _body_shape_index, _local_shape_index):

	if body.is_in_group("Tile"):
		var coords = body.get_coords_for_body_rid(body_rid)

		if body.get_cell_tile_data(1, coords) != null:
			if body.get_cell_tile_data(1, coords).get_custom_data("CollisionType") == "Grapple":
				grappling = true
				position += Vector2(coordsToMoveTowards)
				coordsToMoveTowards = position
				
		
		elif body.get_cell_tile_data(0, coords) != null:
			if body.get_cell_tile_data(0, coords).get_custom_data("CollisionType") == "Wall":
				grappleDirection = -1

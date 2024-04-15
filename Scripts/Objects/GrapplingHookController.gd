extends Area2D

var grappleSpeed : int = 400
var maxGrappleRange : int = 150
var minGrappleRange : int = 15

@onready var audio : Node2D = get_node("sfx")

var player : Player
var grappleDirection : int = 1

func _ready():
	player = get_parent().get_node("Player")

func _physics_process(delta):
	var distanceFromPlayer = position.distance_to(player.position)

	if distanceFromPlayer >= maxGrappleRange:
		grappleDirection = -1
	
	position += transform.x * grappleSpeed * delta * grappleDirection

	if distanceFromPlayer <= minGrappleRange and grappleDirection < 0:
		queue_free()
		






extends Area2D
class_name Grapple

# TODO: sound FX
# TODO: Grapple rope effect
# TODO: Hanging

@export var max_speed : float = 200.0
@export var max_range : float = .65
var grapple_speed : float = max_speed
var attached : bool = false
var retracting : bool = false
var distance_travelled : float = 0.0
var distance_retracted : float = 0.0

func _physics_process(delta):
	position += transform.x * grapple_speed * delta
	
	if !attached and !retracting:
		distance_travelled += delta
	if !attached and retracting:
		distance_retracted += delta

	if distance_travelled >= max_range:
		retract()
	if distance_travelled >= max_range * 2.0:
		queue_free()
	if distance_retracted >= distance_travelled:
		queue_free()
		
func _on_body_shape_entered(body_rid, body, _body_shape_index, _local_shape_index):
	if grapple_speed > 0.0:
		if body.is_class("TileMap"):
			var rid = body.get_layer_for_body_rid(body_rid)
			if rid == 0: # Wall and floor RID
				retract()
			if rid == 1: # Hook RID
				grapple_speed = 0.0
				attached = true
	if grapple_speed <= 0.0:
		if body.is_class("CharacterBody2D"):
			queue_free()

func retract():
	retracting = true
	grapple_speed = -1.0 * max_speed
	

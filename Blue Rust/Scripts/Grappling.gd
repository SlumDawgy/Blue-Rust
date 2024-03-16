extends Area2D

var positionToReach : Vector2
var isMoving : bool = true
var canMovePlayer : bool = false
var cantReturn : bool = false

var player

var collision: Rect2

var aim : bool = false
var endGrappleBool : bool = false
var notWall : bool = false

const speed : float = 500.0
const characterSpeed : float = 250.0


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if isMoving == true:
		position += positionToReach.normalized() * speed * delta
	
	if canMovePlayer == true and aim == false:
		movePlayer(player.position, delta)
	elif canMovePlayer == true and aim == true:
		if Input.is_action_just_pressed("GrapplingHook"):
			aim = false
		if Input.is_action_just_pressed("Crouch"):
			aim = false
			endGrappleBool = true
			canMovePlayer = false
	
	if collision.intersects(player.collision) and isMoving == false: 	# Queue free the projectile
		player.returnGrappling = false
		player.grapplingActive = false
		
		if Input.is_action_pressed("GrapplingHook") == true and canMovePlayer == true: # active Hanging if it reaches a grapplable surface
			player.hangingActive = true
		else: # active Move if it returned
			player.moveActive = true
		
		player.rope.clear_points()
		queue_free()
	
	if endGrappleBool == true:
		endGrapple(player.position, delta)
	
	pass

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	
	if body.is_in_group("Tile"):
		var coords = body.get_coords_for_body_rid(body_rid)
		
	# Find Grapplable Object and move Player
		if body.get_cell_tile_data(0, coords).get_custom_data("CollisionType") == "Grapple":
			position = body.map_to_local(coords)
			isMoving = false
			canMovePlayer = true
			player.returnGrappling = false
			notWall = true
		
		elif body.get_cell_tile_data(0, coords).get_custom_data("CollisionType") == "Wall" and notWall == false:
			player.returnGrappling = true
	
# Move player to grappling hook
func movePlayer(playerFirstPosition, delta):
	player.position += (position - playerFirstPosition).normalized() * characterSpeed * delta

# Return grapplingHook
func endGrapple(playerFirstPosition, delta):
	isMoving = false
	position += (playerFirstPosition - position).normalized() * speed * delta

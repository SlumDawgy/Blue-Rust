extends Node2D

@onready var checkWallRight = $checkWallRight
@onready var checkWallUpRight = $checkWallUpRight

@onready var checkWallLeft = $checkWallLeft
@onready var checkWallUpLeft = $checkWallUpLeft

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if !is_instance_valid(player):
		player = get_parent()
	else:
		checkingWall()
		
		if player.mantlingActive == false:
			player.animation.flip_h = false
		pass

func checkingWall():
	var collider
	var colliderLeft
	
	if checkWallRight.is_colliding() and player.is_on_floor() == false:
		collider = checkWallRight.get_collider()
	if checkWallLeft.is_colliding() and player.is_on_floor() == false:
		colliderLeft = checkWallLeft.get_collider()
	
	
	
	if collider != null:
		if collider.is_in_group("Tile") and player.damageInvincibility <= 0:
			if checkWallUpRight.is_colliding() == false and player.canMantle == true and player.jumping == false:
				player.position = collider.map_to_local(collider.local_to_map(player.position)) - Vector2(4, 0)
				player.animation.flip_h = false
				player.mantlingActive = true
	
	if colliderLeft != null:
		if colliderLeft.is_in_group("Tile") and player.damageInvincibility <= 0:
			if checkWallUpLeft.is_colliding() == false and player.canMantle == true and player.jumping == false:
				player.position = colliderLeft.map_to_local(colliderLeft.local_to_map(player.position)) + Vector2(4, 0)
				player.animation.flip_h = true
				player.mantlingActive = true

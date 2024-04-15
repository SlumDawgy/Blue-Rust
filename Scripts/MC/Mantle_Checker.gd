extends Node2D
class_name MantleCheckerComponent

@export var checkWallRight : RayCast2D
@export var checkWallUpRight : RayCast2D

@export var checkWallLeft : RayCast2D
@export var checkWallUpLeft : RayCast2D

@export var animation : Animations

var character : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	character = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	checkingWall()

func checkingWall():
	if checkWallRight.is_colliding() and character.is_on_floor() == false:
		var collider = checkWallRight.get_collider()
		if collider != null:
			if collider.is_class("TileMap"):
				if checkWallUpRight.is_colliding() == false:
					character.position = collider.map_to_local(collider.local_to_map(character.position)) - Vector2(4, 0)
					character.currentMovement = character.movement.mantling
					animation.play("right_mantling")

	if checkWallLeft.is_colliding() and character.is_on_floor() == false:
		var collider = checkWallLeft.get_collider()
		if collider != null:
			if collider.is_class("TileMap"):
				if checkWallUpLeft.is_colliding() == false:
					character.position = collider.map_to_local(collider.local_to_map(character.position)) + Vector2(4, 0)
					character.currentMovement = character.movement.mantling
					animation.play("left_mantling")

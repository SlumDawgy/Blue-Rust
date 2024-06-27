extends Node2D

@export var sceneToLoad : String
@export var entranceID : int
@export var sceneTransitionNode : Node

@export var playerStartPosition : Node2D
@export var facingRight : bool

func _ready():
	print(GlobalScenes.locationID)
	if GlobalScenes.locationID > -1 and GlobalScenes.locationID == entranceID :
		sceneTransitionNode.player.global_position = playerStartPosition.global_position
		#set facing direction
		pass

func _on_area_2d_body_entered(body):
	if "Player" in body.name :
		
		sceneTransitionNode.changeLevel(sceneToLoad, entranceID)
		

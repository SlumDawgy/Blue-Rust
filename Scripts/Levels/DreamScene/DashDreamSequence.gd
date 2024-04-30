extends Node2D
@export var player : Player
var dialogueFlag1 : bool = true
var dialogueFlag2 : bool = true
var dialogueFlag3 : bool = true

func _ready():
	player.currentMovement = player.movement.disabled
	player.get_node("PlayerSprite").play("getting_up")
	await Dialogic.start("res://Dialogic/Timelines/Dream1-1.dtl")

func _process(delta):
	if Dialogic.VAR.Dialogue6 and dialogueFlag1:
		player.get_node("PlayerSprite").play("right_idle")
		player.currentMovement = player.movement.enabled
		dialogueFlag1 = false
	if Dialogic.VAR.Dialogue7 and dialogueFlag2:
		player.currentMovement = player.movement.enabled
		dialogueFlag2 = false
	if Dialogic.VAR.Dialogue8 and dialogueFlag3:
		dialogueFlag3 = false
		player.currentMovement = player.movement.dying
		

func _on_dash_tutorial_label_body_entered(body):
	if body.name == "Player":
		$Label.visible = true


func _on_dash_tutorial_label_body_exited(body):
	if body.name == "Player":
		$Label.visible = false


func _on_crystal_warning_body_entered(body):
	if body.name == "Player":
		$CrystalWarning.visible = false
		body.get_node("PlayerSprite").playAnimation("idle")
		body.currentMovement = body.movement.disabled
		await Dialogic.start("res://Dialogic/Timelines/Dream1-2.dtl")


func _on_end_of_dream_body_entered(body):
	if body.name == "Player":
		body.get_node("PlayerSprite").play("right_idle")
		body.currentMovement = body.movement.disabled
		await Dialogic.start("res://Dialogic/Timelines/Dream1-3.dtl")



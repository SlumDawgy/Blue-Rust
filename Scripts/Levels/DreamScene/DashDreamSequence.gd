extends Node2D
@export var player : Player
var flagDream1_1 : bool = true
var flagDream1_2 : bool = true
var flagDream1_3 : bool = true

func _ready():
	if Dialogues.Dream1_1:
		flagDream1_1 = false
	if Dialogues.Dream1_2:
		flagDream1_2 = false
	if Dialogues.Dream1_3:
		flagDream1_3 = false
	
	player.currentMovement = player.movement.disabled
	player.get_node("PlayerSprite").play("getting_up")
	Dialogic.start("res://Dialogic/Timelines/Dream1-1.dtl")

func _process(delta):
	if Dialogues.Dream1_1 and flagDream1_1:
		player.get_node("PlayerSprite").play("right_idle")
		player.currentMovement = player.movement.enabled
		flagDream1_1 = false
	if Dialogues.Dream1_2 and flagDream1_2:
		player.currentMovement = player.movement.enabled
		flagDream1_2 = false
	if Dialogues.Dream1_3 and flagDream1_3:
		flagDream1_3 = false
		player.currentMovement = player.movement.dying
		

func _on_dash_tutorial_label_body_entered(body):
	if body.name == "Player":
		$Label.visible = true


func _on_dash_tutorial_label_body_exited(body):
	if body.name == "Player":
		$Label.visible = false


func _on_crystal_warning_body_entered(body):
	if body.name == "Player":
		$CrystalWarning.queue_free()
		body.get_node("PlayerSprite").playAnimation("idle")
		body.currentMovement = body.movement.disabled
		Dialogic.start("res://Dialogic/Timelines/Dream1-2.dtl")


func _on_end_of_dream_body_entered(body):
	if body.name == "Player":
		$EndOfDream.queue_free()
		body.get_node("PlayerSprite").play("right_idle")
		body.currentMovement = body.movement.disabled
		body.dashEnabled = false
		Dialogic.start("res://Dialogic/Timelines/Dream1-3.dtl")



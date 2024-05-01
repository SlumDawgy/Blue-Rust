extends Control
class_name GameUI

@export var player : Player

var health : HealthComponent

var lanturnFull = load(GlobalPaths.LANTURN_FULL_PATH)
var lanturnEmpty = load(GlobalPaths.LANTURN_EMPTY_PATH)

@onready var healthContainer : HBoxContainer = $HBoxContainer

## Called when the node enters the scene tree for the first time.
func _ready():
	health = player.get_node("HealthComponent")
	print(player)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	changeHealth()
	#if Input.is_action_just_pressed("ui_right"):
		#increaseHealth()
	#elif Input.is_action_just_pressed("ui_left"):
		#decreaseHealth()
	#elif Input.is_action_just_pressed("ui_up"):
		#increaseMaxHealth()
	#elif Input.is_action_just_pressed("ui_down"):
		#decreaseMaxHealth()
	pass

func changeHealth():
	for lanturns in range(healthContainer.get_child_count()):
		if healthContainer.get_child_count() - lanturns > (health.maxHealth - health.health):
			healthContainer.get_node("Heart" + str(lanturns + 1)).texture = lanturnFull
		else:
			healthContainer.get_node("Heart" + str(lanturns + 1)).texture = lanturnEmpty

#func decreaseHealth():
	#if currentHealth > 0:
		#currentHealth -= 1
		#player.currentHealth -= 1
	#if get_node("HBoxContainer/Heart" + str(currentHealth + 1)) != null:
		#get_node("HBoxContainer/Heart" + str(currentHealth + 1)).texture = load(GlobalPaths.LANTURN_EMPTY_PATH)
#
#func increaseHealth():
	#if currentHealth < maxHealth:
		#currentHealth += 1
		#player.currentHealth += 1
	#if get_node("HBoxContainer/Heart" + str(currentHealth)) != null:
		#get_node("HBoxContainer/Heart" + str(currentHealth)).texture = load(GlobalPaths.LANTURN_FULL_PATH)
#
#func increaseMaxHealth():
	#maxHealth += 1
	#player.maxHealth += 1
	#if currentHealth < maxHealth:
		#currentHealth = maxHealth
		#player.currentHealth = maxHealth
	#var newHeart = get_node("HBoxContainer/Heart1").duplicate(1)
	#newHeart.name = "Heart" + str(maxHealth)
	#get_node("HBoxContainer").add_child(newHeart)
	#for restore in range(1, maxHealth + 1):
		#get_node("HBoxContainer/Heart" + str(restore)).texture = load(GlobalPaths.LANTURN_FULL_PATH)
		#
#
#func decreaseMaxHealth():
	#if maxHealth > 1:
		#maxHealth -= 1
		#player.maxHealth -= 1
		#if currentHealth > maxHealth:
			#currentHealth -= 1
			#player.currentHealth -= 1
		#get_node("HBoxContainer/Heart" + str(maxHealth + 1)).queue_free()

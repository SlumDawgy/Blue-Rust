extends Control
class_name GameUI

@export var player : Player

var health : HealthComponent
@onready var healthbar = $HealthGuage/HealthBar
@onready var breathbar = $HealthGuage/BreathBar

var lanturnFull = load(GlobalPaths.LANTURN_FULL_PATH)
var lanturnEmpty = load(GlobalPaths.LANTURN_EMPTY_PATH)
var breathFull = load(GlobalPaths.BREATH_FULL_PATH)
var breathEmpty = load(GlobalPaths.BREATH_EMPTY_ICON)

@onready var healthContainer : HBoxContainer = $HBoxContainer
@onready var breathContainer : HBoxContainer = $BreathContainer

## Called when the node enters the scene tree for the first time.
func _ready():
	player = GlobalReferences.player
	health = player.get_node("HealthComponent")
	healthbar.max_value = health.maxHealth
	breathbar.max_value = health.maxBreath
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	changeHealth()
	handleBreath()
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
	healthbar.value = lerp(healthbar.value,  health.health, 0.2)
	
func handleBreath (): 
	breathbar.value = lerp(breathbar.value,  health.currentBreath, 0.2)

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

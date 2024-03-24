extends Control

@export var maxHealth : int = 3
@export var currentHealth : int = 3

var deathScreen

var player

var respawnPosition : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	deathScreen = preload("res://Scenes/death_ui.tscn")
	player = get_parent().get_parent().get_parent().get_node("Player")
	respawnPosition = player.position
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_right"):
		increaseHealth()
	elif Input.is_action_just_pressed("ui_left"):
		decreaseHealth()
	elif Input.is_action_just_pressed("ui_up"):
		increaseMaxHealth()
	elif Input.is_action_just_pressed("ui_down"):
		decreaseMaxHealth()
	
	if currentHealth == 0:
		endGame()


func decreaseHealth():
	if currentHealth > 0:
		currentHealth -= 1

	if get_node("HBoxContainer/Heart" + str(currentHealth + 1)) != null:
		get_node("HBoxContainer/Heart" + str(currentHealth + 1)).texture = load("res://Assets/Sprites/Laturn/laturn_empty.png")
	

func increaseHealth():
	if currentHealth < maxHealth:
		currentHealth += 1
	
	if get_node("HBoxContainer/Heart" + str(currentHealth)) != null:
		get_node("HBoxContainer/Heart" + str(currentHealth)).texture = load("res://Assets/Sprites/Laturn/laturn_full.png")

func increaseMaxHealth():
	maxHealth += 1
	if currentHealth < maxHealth:
		currentHealth = maxHealth
	
	var newHeart = get_node("HBoxContainer/Heart1").duplicate(1)
	
	newHeart.name = "Heart" + str(maxHealth)
	
	get_node("HBoxContainer").add_child(newHeart)
	
	for restore in range(1, maxHealth + 1):
		get_node("HBoxContainer/Heart" + str(restore)).texture = load("res://Assets/Sprites/Laturn/laturn_full.png")
		

func decreaseMaxHealth():
	if maxHealth > 1:
		maxHealth -= 1
		if currentHealth > maxHealth:
			currentHealth -= 1
		
		get_node("HBoxContainer/Heart" + str(maxHealth + 1)).queue_free()

func endGame():
	player.deadActive = true
	var deathScreenChild = deathScreen.instantiate()
	
	if get_parent().get_node("Death_UI") == null:
		get_parent().add_child(deathScreenChild)

func respawn():
	player.position = respawnPosition
	player.moveActive = true
	for i in range(maxHealth):
		increaseHealth()
	player.deadActive = false
	pass

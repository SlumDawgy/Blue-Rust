extends Control

@export var maxHealth : int = 3
@export var currentHealth : int = 3

var deathScreen

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	deathScreen = preload("res://Scenes/death_ui.tscn")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !is_instance_valid(player):
		player = get_tree().get_first_node_in_group("Player")
		
		if maxHealth != player.maxHealth:
			while(maxHealth != player.maxHealth):
				if maxHealth < player.maxHealth:
					increaseMaxHealth()
				elif maxHealth > player.maxHealth:
					decreaseMaxHealth()
		if currentHealth != player.currentHealth:
			while(currentHealth != player.currentHealth):
				if currentHealth < player.currentHealth:
					increaseHealth()
				elif currentHealth > player.currentHealth:
					decreaseHealth()
	else:
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
		player.currentHealth -= 1

	if get_node("HBoxContainer/Heart" + str(currentHealth + 1)) != null:
		get_node("HBoxContainer/Heart" + str(currentHealth + 1)).texture = load("res://Assets/Sprites/Laturn/laturn_empty.png")
	

func increaseHealth():
	if currentHealth < maxHealth:
		currentHealth += 1
		player.currentHealth += 1
	
	if get_node("HBoxContainer/Heart" + str(currentHealth)) != null:
		get_node("HBoxContainer/Heart" + str(currentHealth)).texture = load("res://Assets/Sprites/Laturn/laturn_full.png")

func increaseMaxHealth():
	maxHealth += 1
	player.maxHealth += 1
	if currentHealth < maxHealth:
		currentHealth = maxHealth
		player.currentHealth = maxHealth
	
	var newHeart = get_node("HBoxContainer/Heart1").duplicate(1)
	
	newHeart.name = "Heart" + str(maxHealth)
	
	get_node("HBoxContainer").add_child(newHeart)
	
	for restore in range(1, maxHealth + 1):
		get_node("HBoxContainer/Heart" + str(restore)).texture = load("res://Assets/Sprites/Laturn/laturn_full.png")
		

func decreaseMaxHealth():
	if maxHealth > 1:
		maxHealth -= 1
		player.maxHealth -= 1
		if currentHealth > maxHealth:
			currentHealth -= 1
			player.currentHealth -= 1
		
		get_node("HBoxContainer/Heart" + str(maxHealth + 1)).queue_free()

func endGame():
	if player != null:
		player.deadActive = true
		var deathScreenChild = deathScreen.instantiate()
		
		if get_parent().get_node("Death_UI") == null:
			get_parent().add_child(deathScreenChild)

func respawn():
	get_tree().reload_current_scene()
	pass

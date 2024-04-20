extends Control

@onready var lanturn = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 0
	get_tree().paused = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if modulate.a < 1:
		modulate.a += 2 * delta
	
	elif modulate.a >= 1:
		lanturn.play("default")
	
	if lanturn.frame == 6:
		lanturn.pause()
	
	pass


func _on_continue_button_down():
	get_parent().get_node("GameUI").respawn()
	queue_free()
	pass # Replace with function body.


func _on_quit_button_down():
	if FileAccess.file_exists("user://savegame.save"):
		DirAccess.remove_absolute("user://savegame.save")
	get_tree().quit()
	pass # Replace with function body.

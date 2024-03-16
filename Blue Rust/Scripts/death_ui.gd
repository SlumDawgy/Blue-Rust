extends Control

@onready var lanturn = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 0
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
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_quit_button_down():
	get_tree().quit()
	pass # Replace with function body.

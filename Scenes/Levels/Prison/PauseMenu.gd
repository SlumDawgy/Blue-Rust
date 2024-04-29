extends Panel
	
func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
		visible = false
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		
	else:
		visible = true
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	
func _on_resume_button_pressed():
	print(get_parent())
	visible = false
	get_tree().paused = false

func _on_options_button_pressed():
	pass # Replace with function body.

func _on_quit_button_pressed():
	get_tree().quit()

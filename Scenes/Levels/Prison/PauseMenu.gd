extends Panel
	
@export var buttonSelectSound : AudioStream
@export var buttonClickSound : AudioStream
@export var menuOpenSound: AudioStream
@export var menuCloseSound: AudioStream
	
func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		AudioManager.play_sound(menuOpenSound)
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
	AudioManager.play_sound(buttonClickSound)
	AudioManager.play_sound(menuCloseSound)
	visible = false
	get_tree().paused = false

func _on_options_button_pressed():
	AudioManager.play_sound(buttonClickSound)
	pass # Replace with function body.

func _on_quit_button_pressed():
	AudioManager.play_sound(buttonClickSound)
	AudioManager.play_sound(menuCloseSound)
	get_tree().quit()


func _on_resume_button_mouse_entered():
	AudioManager.play_sound(buttonSelectSound)


func _on_options_button_mouse_entered():
	AudioManager.play_sound(buttonSelectSound)


func _on_quit_button_mouse_entered():
	AudioManager.play_sound(buttonSelectSound)
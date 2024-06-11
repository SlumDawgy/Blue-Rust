extends Panel
	
@export var buttonSelectSound : AudioStream
@export var buttonClickSound : AudioStream
@export var menuOpenSound: AudioStream
@export var menuCloseSound: AudioStream
	
func _process(_delta):
	if Input.is_action_just_pressed("Pause") and Dialogic.current_timeline == null:
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
	AudioManager.play_sound(buttonClickSound)
	AudioManager.play_sound(menuCloseSound)
	visible = false
	get_tree().paused = false

func _on_options_button_pressed():
	AudioManager.play_sound(buttonClickSound)
	$PauseMenuButtons.visible = false
	$OptionsPanel.visible = true

func _on_quit_button_pressed():
	AudioManager.play_sound(buttonClickSound)
	AudioManager.play_sound(menuCloseSound)
	$"../../../Scenetransition".transition()
	await get_tree().create_timer(1.5).timeout
	Loadings.loadingScene("Main_Menu", 0)

func _on_resume_button_mouse_entered():
	AudioManager.play_sound(buttonSelectSound)

func _on_options_button_mouse_entered():
	AudioManager.play_sound(buttonSelectSound)

func _on_quit_button_mouse_entered():
	AudioManager.play_sound(buttonSelectSound)

func _on_back_button_pressed():
	AudioManager.play_sound(buttonSelectSound)
	$OptionsPanel.visible = false
	$PauseMenuButtons.visible = true

func _on_load_last_save_button_mouse_entered():
	AudioManager.play_sound(buttonSelectSound)

func _on_load_last_save_button_pressed():
	AudioManager.play_sound(buttonSelectSound)
	$"../../..".load_game()
	toggle_pause()

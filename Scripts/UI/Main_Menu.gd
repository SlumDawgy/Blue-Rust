extends Control

@export var startGameSFX:AudioStream
@export var buttonClickSFX:AudioStream
@export var buttonSelectSFX:AudioStream
var optionsScene = preload(GlobalPaths.OPTIONS_SCREEN_PATH)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	$Scenetransition.fadetonormal()

func _on_start_pressed():
	$Scenetransition.transition()
	AudioManager.play_sound(startGameSFX)


func _on_options_pressed():
	AudioManager.play_sound(buttonClickSFX)
	pass


func _on_quit_pressed():
	AudioManager.play_sound(buttonClickSFX)
	get_tree().quit()

func _on_Scenetransition_Finished():
	pass



func _on_start_button_mouse_entered():
	AudioManager.play_sound(buttonSelectSFX)


func _on_options_mouse_entered():
	AudioManager.play_sound(buttonSelectSFX)


func _on_quit_mouse_entered():
	AudioManager.play_sound(buttonSelectSFX)

extends Control

@export var startGameSFX:AudioStream
@export var buttonClickSFX:AudioStream
@export var buttonSelectSFX:AudioStream
var optionsScene = preload(GlobalPaths.OPTIONS_SCREEN_PATH)

func _ready():
	$Scenetransition.fadetonormal()

func _on_start_pressed():
	$Scenetransition.transition()
	AudioManager.play_sound(startGameSFX)


func _on_options_pressed():
	pass


func _on_quit_pressed():
	get_tree().quit()

func _on_Scenetransition_Finished():
	
	pass



func _on_start_button_mouse_entered():
	AudioManager.play_sound(buttonSelectSFX)


func _on_options_mouse_entered():
	AudioManager.play_sound(buttonSelectSFX)


func _on_quit_mouse_entered():
	AudioManager.play_sound(buttonSelectSFX)

extends Control

@export var startGameSFX:AudioStream
@export var buttonClickSFX:AudioStream
@export var buttonSelectSFX:AudioStream
@export var options : Sprite2D
@export var menu : CanvasLayer = get_parent()
var optionsScene = preload(GlobalPaths.OPTIONS_SCREEN_PATH)

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	$Scenetransition.fadetonormal()

func _on_back_button_pressed():
	AudioManager.play_sound(buttonClickSFX)
	options.hide()
	menu.show()

func _on_Scenetransition_Finished():
	pass

func _on_back_button_mouse_entered():
	AudioManager.play_sound(buttonSelectSFX)


func _on_start_button_pressed():
	$Scenetransition.transition()
	AudioManager.play_sound(startGameSFX)
	await get_tree().create_timer(2).timeout
	Loadings.loadingScene("Prison", 0)

func _on_load_pressed():
	$Scenetransition.transition()
	AudioManager.play_sound(startGameSFX)
	await get_tree().create_timer(2).timeout
	Loadings.loadingScene("Prison", 1)
	pass # Replace with function body.

func _on_options_pressed():
	AudioManager.play_sound(buttonClickSFX)
	options.show()
	menu.hide()
	


func _on_quit_pressed():
	AudioManager.play_sound(buttonClickSFX)
	get_tree().quit()


func _on_quit_mouse_entered():
	AudioManager.play_sound(buttonSelectSFX)


func _on_options_mouse_entered():
	AudioManager.play_sound(buttonSelectSFX)


func _on_start_button_mouse_entered():
	AudioManager.play_sound(buttonSelectSFX)


func _on_fullscreen_button_toggled(_toggled_on):
	AudioManager.play_sound(buttonClickSFX)
	
func _off_fullscreen_button_toggled(_toggled_on):
	AudioManager.play_sound(buttonClickSFX)


func _on_load_mouse_entered():
	AudioManager.play_sound(buttonSelectSFX)

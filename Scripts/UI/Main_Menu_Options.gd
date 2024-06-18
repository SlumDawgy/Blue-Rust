extends Sprite2D

@onready var master = %Master
@onready var music_slider = %MusicSlider
@onready var sfx_slider = %SFXSlider

@onready var option_button = %OptionButton


var user_prefs : UserPreferences

func _ready():
	user_prefs = UserPreferences.load_or_create()
	if sfx_slider:
		sfx_slider.value = user_prefs.sfx_audio_level
	if music_slider:
		music_slider.value = user_prefs.music_audio_level
	if master:
		master.value = user_prefs.master_audio_level
	if option_button:
		_on_option_button_item_selected(user_prefs.language_selected)
	

func _on_button_pressed():
	queue_free()

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	if user_prefs:
		user_prefs.sfx_audio_level = value
		user_prefs.save()

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), linear_to_db(value))
	if user_prefs:
		user_prefs.music_audio_level = value
		user_prefs.save()

func _on_master_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	if user_prefs:
		user_prefs.master_audio_level = value
		user_prefs.save()

func _on_fullscreen_button_toggled(toggled_on):
	if toggled_on:
		get_tree().root.set_mode(Window.MODE_FULLSCREEN)
	else:
		get_tree().root.set_mode(Window.MODE_MAXIMIZED)

func _on_option_button_item_selected(index):
	if index == 0:
		TranslationServer.set_locale("en")
		option_button.selected = 0
	elif index == 1:
		TranslationServer.set_locale("pt_BR")
		option_button.selected = 1
	
	if user_prefs:
		user_prefs.language_selected = index
		user_prefs.save()



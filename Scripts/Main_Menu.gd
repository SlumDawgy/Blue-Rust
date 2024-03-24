extends Control

var optionsScene = preload(("res://Scenes/Main_Menu_Options.tscn"))

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")


func _on_options_pressed():
	pass


func _on_quit_pressed():
	get_tree().quit()




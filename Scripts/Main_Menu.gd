extends Control

var optionsScene = preload(("res://Scenes/Main_Menu_Options.tscn"))

func _ready():
	$Scenetransition.fadetonormal()

func _on_start_pressed():
	$Scenetransition.transition()
	


func _on_options_pressed():
	pass


func _on_quit_pressed():
	get_tree().quit()

func _on_Scenetransition_Finished():
	
	pass


extends Button

@export var menu : CanvasLayer

func _on_pressed():
	get_parent().hide()
	menu.show()

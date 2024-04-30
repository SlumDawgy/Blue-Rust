extends Control

func _ready():
	modulate.a = 0
	get_tree().paused = true


func _on_continue_button_down():
	get_parent().get_node("GameUI").respawn()
	queue_free()


func _on_quit_button_down():
	get_tree().quit()


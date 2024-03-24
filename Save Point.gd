extends Area2D

var canSave = false

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $AnimatedSprite2D.is_playing() == false:
		$AnimatedSprite2D.play("default")
	
	if canSave == true and Input.is_action_just_pressed("useItem"):
		get_parent().get_node("Camera/CanvasLayer/GameUI").respawnPosition = player.position
	pass


func _on_body_entered(body):
	if body.is_in_group("Player"):
		canSave = true
		$Label.visible = true
	
	pass # Replace with function body.


func _on_body_exited(body):
	if body.is_in_group("Player"):
		canSave = false
		$Label.visible = false
	pass # Replace with function body.

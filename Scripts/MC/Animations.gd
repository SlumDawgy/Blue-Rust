extends AnimatedSprite2D
class_name Animations

@onready var player = $".."
@onready var armPivo = $ArmPivo
@onready var armSprite = $ArmPivo/Arm
@onready var HookPathPivo = $ArmPivo/Arm/GrappleOrigin
@onready var armYOffset = $ArmPivo/Arm.offset.y

func playAnimation(type):
	var cursorXcoord = (to_global(position) - get_global_mouse_position()).normalized().x
	var direction

	if cursorXcoord < 0:
		direction = "right_"
	else:
		direction = "left_"

	if get_parent().get_node_or_null("Grappling") != null:
		pass
	elif animation != direction + type:
		play(direction + type)


func chooseAnimation():
	match player.currentMovement:
		player.movement.disabled:
			playAnimation("idle")
		player.movement.enabled:
			if player.velocity.x != 0:
				playAnimation("running")
			else:
				playAnimation("idle")
		player.movement.jumping:
			if player.velocity.y < 0:
				playAnimation("jump")
			else:
				playAnimation("fall")
		#player.movement.mantling: #Already in the mantling script
			#pass
		player.movement.grappling:
			pass
		player.movement.hanging:
			pass
		player.movement.dashing:
			pass
		player.movement.dying:
			pass

func _process(delta):
	chooseAnimation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if get_parent().get_parent().get_node_or_null("Grappling") != null:
		pass
	else:
		if animation.begins_with("left"):
			#armSprite.flip_h = true
			armSprite.flip_v = true
			armSprite.offset.y = armYOffset
			armSprite.z_index = -1
			armPivo.look_at(get_global_mouse_position())

		if animation.begins_with("right"):
			armSprite.flip_v = false
			#armSprite.flip_h = false			
			armSprite.offset.y = armYOffset
			armSprite.z_index = 0
			armPivo.look_at(get_global_mouse_position())

		armPivo.rotation_degrees = fmod(armPivo.rotation_degrees, 360.0)

	movingPivot()
	

func movingPivot():
	if animation == "right_running":
		match frame:
				0: armPivo.position = Vector2(2, -4.5)
				1: armPivo.position = Vector2(3, -6.5)
				2: armPivo.position = Vector2(2, -6.5)
				3: armPivo.position = Vector2(4, -5.5)
				4: armPivo.position = Vector2(3, -4.5)
				5: armPivo.position = Vector2(3, -6.5)
				6: armPivo.position = Vector2(3, -5.5)
				7: armPivo.position = Vector2(5, -5.5)
	elif animation == "right_jump":
		match frame:
				0: armPivo.position = Vector2(-1.5, -7.5)
				1: armPivo.position = Vector2(-1.5, -7.5)
	elif animation == "right_fall":
		match frame:
				0: armPivo.position = Vector2(-1.5, -8.5)
				1: armPivo.position = Vector2(-1.5, -8.5)
	elif animation == "right_idle":
		armPivo.position = Vector2(-1.5, -7.5)
	elif animation == "left_running":
		match frame:
				0: armPivo.position = Vector2(-7, -4.5)
				1: armPivo.position = Vector2(-6, -6.5)
				2: armPivo.position = Vector2(-4, -6.5)
				3: armPivo.position = Vector2(-5, -5.5)
				4: armPivo.position = Vector2(-6, -4.5)
				5: armPivo.position = Vector2(-7, -6.5)
				6: armPivo.position = Vector2(-3, -5.5)
				7: armPivo.position = Vector2(-3, -5.5)
	elif animation == "left_idle":
		armPivo.position = Vector2(1.5, -7.5)
	elif animation == "left_jump":
		match frame:
			0: armPivo.position = Vector2(1.5, -7.5)
			1: armPivo.position = Vector2(1.5, -7.5)
	elif animation == "left_fall":
		match frame:
				0: armPivo.position = Vector2(1.5, -5.5)
				1: armPivo.position = Vector2(1.5, -5.5)

	if animation == "right_mantling" or animation == "right_hanging" or animation == "left_hanging" or animation == "left_damage" or animation == "right_damage":
		armPivo.visible = false
	else:
		armPivo.visible = true

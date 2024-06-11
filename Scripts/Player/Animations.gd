extends AnimatedSprite2D
class_name Animations

@onready var player = $".."
@onready var armSprite = $Arm
@onready var HookPathPivo = $Arm/GrappleOrigin

var useController : bool = true
var aimVector : Vector2
var cursorXcoord 
var direction : String
	
func playAnimation(type):
	if not useController:
		cursorXcoord = (to_global(position) - get_global_mouse_position()).normalized().x
	else:
		cursorXcoord = -1.0 * Input.get_vector("Aim_Left","Aim_Right","Aim_Down","Aim_Up").normalized().x
				
		print(cursorXcoord)
		
	if cursorXcoord < 0:
		direction = "right_"
	elif cursorXcoord > 0:
		direction = "left_"
	else:
		pass

	if get_parent().get_node_or_null("Grappling") != null:
		pass
	elif animation != direction + type:
		play(direction + type)


func chooseAnimation():
	match player.currentMovement:
		player.movement.disabled:
			pass
		player.movement.enabled:
			if player.velocity.x < 0:
				play("left_running")
			elif player.velocity.x > 0:
				play("right_running")
			else:
				playAnimation("idle")
		player.movement.jumping:
			if player.velocity.y < 0:
				playAnimation("jump")
			else:
				playAnimation("fall")
		player.movement.grappling:
			if player.is_on_floor():
				playAnimation("idle")
			else:
				if player.velocity.y < 0:
					playAnimation("jump")
				else:
					playAnimation("fall")
		player.movement.hanging:
			playAnimation("hanging")
		player.movement.hangingJump:
			if player.velocity.y < 0:
				playAnimation("jump")
			else:
				playAnimation("fall")
		player.movement.dashing:
			if animation != "left_dash" and animation != "right_dash" and player.dashEnabled:
				playAnimation("dash")
		player.movement.gliding:
			if animation.contains("parasol") == false:
				print(10)
				playAnimation("parasol_open")
				await animation_finished
				playAnimation("parasol_glid")
			elif animation.ends_with("glid"):
				playAnimation("parasol_glid")
			if Input.is_action_just_released("Parasol") and not owner.is_on_floor():
				playAnimation("parasol_close")
				await animation_finished
				owner.currentMovement = owner.movement.jumping
		player.movement.takingDamage:
			playAnimation("damage")
		player.movement.dying:
			if player.is_on_floor() and animation != "death":
				play("death")
				$"../PlayerLight".enabled = false

func _process(_delta):
	chooseAnimation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if get_parent().get_parent().get_node_or_null("Grappling") != null:
		pass
	else:
		if animation.begins_with("left"):
			armSprite.flip_v = true
			armSprite.z_index = -1
			if not useController:
				armSprite.look_at(get_global_mouse_position())
			else:
				aimVector = Input.get_vector("Aim_Left","Aim_Right","Aim_Down","Aim_Up")
				armSprite.look_at(aimVector)
				#armSprite.rotation = aimVector
		if animation.begins_with("right"):
			armSprite.flip_v = false
			armSprite.z_index = 0
			
			if not useController:
				armSprite.look_at(get_global_mouse_position())
			else:
				aimVector = Input.get_vector("Aim_Left","Aim_Right","Aim_Down","Aim_Up")
				armSprite.look_at(aimVector)
				#armSprite.rotation = aimVector

		armSprite.rotation_degrees = fmod(armSprite.rotation_degrees, 360.0)

	movingPivot()
	

func movingPivot():
	if animation == "right_running":
		match frame:
				0: armSprite.position = Vector2(2, -4.5)
				1: armSprite.position = Vector2(3, -6.5)
				2: armSprite.position = Vector2(2, -6.5)
				3: armSprite.position = Vector2(4, -5.5)
				4: armSprite.position = Vector2(3, -4.5)
				5: armSprite.position = Vector2(3, -6.5)
				6: armSprite.position = Vector2(3, -5.5)
				7: armSprite.position = Vector2(5, -5.5)
	elif animation == "right_jump":
		match frame:
				0: armSprite.position = Vector2(-1.5, -7.5)
				1: armSprite.position = Vector2(-1.5, -7.5)
	elif animation == "right_fall":
		match frame:
				0: armSprite.position = Vector2(-1.5, -8.5)
				1: armSprite.position = Vector2(-1.5, -8.5)
	elif animation == "right_idle":
		armSprite.position = Vector2(-1.5, -7.5)
	elif animation == "left_running":
		match frame:
				0: armSprite.position = Vector2(-7, -4.5)
				1: armSprite.position = Vector2(-6, -6.5)
				2: armSprite.position = Vector2(-4, -6.5)
				3: armSprite.position = Vector2(-5, -5.5)
				4: armSprite.position = Vector2(-6, -4.5)
				5: armSprite.position = Vector2(-7, -6.5)
				6: armSprite.position = Vector2(-3, -5.5)
				7: armSprite.position = Vector2(-3, -5.5)
	elif animation == "left_idle":
		armSprite.position = Vector2(1.5, -7.5)
	elif animation == "left_jump":
		match frame:
			0: armSprite.position = Vector2(1.5, -7.5)
			1: armSprite.position = Vector2(1.5, -7.5)
	elif animation == "left_fall":
		match frame:
				0: armSprite.position = Vector2(1.5, -5.5)
				1: armSprite.position = Vector2(1.5, -5.5)
	elif animation == "right_dash":
		armSprite.position = Vector2(0.5, -4.5)

	if player.currentMovement == player.movement.hanging or player.currentMovement == player.movement.mantling or animation == "death" or animation == "getting_up":
		armSprite.visible = false
	else:
		armSprite.visible = true

#func _on_animation_finished():
	#var currentSceneName = get_tree().get_current_scene().name
	#if animation == "death" and currentSceneName == "Prison":
		#get_tree().root.get_node("Prison").get_node("Scenetransition/AnimationPlayer").play("Fade_To_Black")
	#

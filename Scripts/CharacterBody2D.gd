extends CharacterBody2D

@onready var jumpBufferingCast = $jumpBufferingCast

@onready var animation = $AnimatedSprite2D

# Mouse Follower
@onready var mouseFollower = $Aim_Assist
@onready var rope = $Rope

# Movement variables
var moveActive : bool = true
var grapplingActive : bool = false
var mantlingActive : bool = false
var deadActive : bool = false

# Speed
const SPEED : float = 115.0
var target_velocity : Vector2

# Jump Variables
var coyoteTime : float = 0.01
var jumpBuffering : bool = false
var doubleJump : bool = false

var jumpHolding : bool = false
var jumpTimer : float = 0.0

var jumpHeight : float
var jump_target_velocity : float = -200.0
var jumping : bool = false
var gravityVar : float = 0.75

# Can mantle edge
var canMantle : bool = true

# Grappling Hook
var positionToReach : Vector2
var returnGrappling : bool = false
var grapplingHookProjectile

var hangingActive : bool = false
var balancing : bool = false
var littleDash : bool = false

# Dash
var dashTime : float = 0.0
var dashUses : int = 1

# Damage
var takingDamage = false
var hookPathActive : bool = true
var aimAssistActive : bool = true
# Get gravity
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Damage
var damageInvencibility := 0.0

# Difficulty
var difficulty := 0

# Health
var currentHealth := 3
var maxHealth := 3

# Power Ups Activation
var doubleJumpUpgrade : bool = false
var dashUpgrade : bool = true

# Sounds
var audios

func _ready():
	grapplingHookProjectile = preload("res://Scenes/Grappling.tscn")
	audios = get_node("Audios")

func _physics_process(delta):
	
	if jumpHolding == true:
		jumpTimer += delta
	
	velocity = target_velocity
	
	# Movements
	if moveActive:
		walk(delta)
	if grapplingActive:
		grappling(delta)
		canMantle = false
	if mantlingActive:
		mantling()
	if deadActive:
		dead()
	if hangingActive:
		hanging()
	if  balancing == true:
		var direction = 0
		
		if animation.animation.begins_with("right"):
			animation.play("right_hanging")
			direction = 1
		elif animation.animation.begins_with("left"):
			animation.play("left_hanging")
			direction = -1


		hangingActive = false
		balancing = false
		littleDash = true
		target_velocity.x = 200 * direction
		target_velocity.y = -200
		moveActive = true
	
	# Fall Animation
	if jumping == false and is_on_floor() == false and animation.animation != "right_mantling" and hangingActive == false:
		if animation.animation.begins_with("right"):
			animations("right_fall")
		elif  animation.animation.begins_with("left"):
			animations("left_fall")
	
	# Damage
	if takingDamage:
		damage()
	
	# Power Ups
	useDash(delta)

	move_and_slide()

	# Body Collision
	
	
	if damageInvencibility > 0:
		damageInvencibility -= delta
	else:
		set_collision_layer_value(5, true)
	
	mouseFollower.position = get_local_mouse_position()


func _process(_delta):
	if Input.is_action_just_pressed("GrapplingHook") and get_parent().get_node_or_null("Grappling") == null and mantlingActive == false and hangingActive == false and deadActive == false and dashTime == 0:
		grapplingActive = true
		moveActive = false
		jumping = false
		gravityVar = 0.75
	
	if Input.is_action_just_pressed("Dash") and dashUpgrade == true and dashUses > 0 and hangingActive == false and grapplingActive == false and mantlingActive == false:
		target_velocity = Vector2(0,0)
		littleDash = false
		dashTime = 0.1
		dashUses -= 1
	
	# Use Item
	if Input.is_action_just_pressed("useItem"):
		useItem()
	
	if Input.is_action_just_pressed("changeDifficulty"):
		decreaseDifficulty()


# Walking / Running
func walk(delta):
	var direction = Input.get_axis("MoveLeft", "MoveRight")
	if direction and littleDash == false:
		target_velocity.x = direction * SPEED
		
		if direction < 0:
			if animation.animation != "left_running" and jumping == false:
				animations("left_running")
		elif direction > 0:
			if animation.animation != "right_running" and jumping == false:
				animations("right_running")

	elif littleDash == false:
		target_velocity.x = move_toward(target_velocity.x, 0, SPEED)
		
		if animation.animation.begins_with("right"):
			animations("right_idle")
		elif animation.animation.begins_with("left"):
			animations("left_idle")
	
	# Add Jump Buffering
	if jumpBufferingCast.is_colliding() and Input.is_action_just_pressed("Jump"):
			jumpBuffering = true
	
	# Is On Floor activations
	if is_on_floor():
		coyoteTime = 0.5
		if dashTime <= 0:
			dashUses = 1
		if target_velocity.y > 0:
			target_velocity.y = 0

		canMantle = true
		balancing = false
		littleDash = false
		jumpTimer = 0
		
		if animation.animation == "right_fall":
			animations("right_idle")
		elif animation.animation == "left_fall":
			animations("left_idle")

	# Jump + Jump Buffering + Coyote Time + Double Jump
	if (Input.is_action_just_pressed("Jump")and coyoteTime > 0) or (jumpBuffering and is_on_floor()):
		jumpBuffering = false
		jumpHeight = position.y - 32
		gravityVar = 0.75
		jumpHolding = true
		jumping = true
		
		if doubleJumpUpgrade == true:
			doubleJump = true
		
	
	if (Input.is_action_just_released("Jump")):
			jumpHolding = false
			jumpTimer = -1
	elif jumpTimer >= 0.1:
			jumpHolding = false
			jumpTimer = 0
			jumpHeight -= 32
	
	if doubleJump == true and Input.is_action_just_pressed("Jump") and is_on_floor() == false:
		jumpHeight = position.y - 32
		jumping = true
		gravityVar = 0.5
		coyoteTime = -1
		jumpBuffering = false
		doubleJump = false
	
	if jumping == true:
		coyoteTime = -1
		if animation.animation != "right_jump" and animation.animation.begins_with("right"):
			animations("right_jump")
		if animation.animation != "left_jump" and animation.animation.begins_with("left"):
			animations("left_jump")
		if position.y <= jumpHeight:
			jumping = false
			jumpHolding = false
			gravityVar = 0.75
			target_velocity.y = move_toward(0, target_velocity.y, SPEED)
		target_velocity.y = jump_target_velocity
	
	if not is_on_floor():
		target_velocity.y += gravity * delta * gravityVar
		coyoteTime -= delta * 3

# Grappling
func grappling(delta):
	target_velocity.y = gravity * delta * 1.5
	
	var grapplingHookChild = grapplingHookProjectile.instantiate()
	
	if Input.is_action_pressed('Aim') and grapplingHookChild.aim == false and is_on_floor():
		grapplingHookChild.aim = true
	
	if get_parent().get_node_or_null("Grappling") == null:
		littleDash = false
		target_velocity.x = move_toward(target_velocity.x, 0, SPEED)
		
		
		
		var directionToPosition = (to_local(position) - get_local_mouse_position()).normalized()
		grapplingHookChild.rotation =  PI + atan2(directionToPosition.y, directionToPosition.x) 


		if get_parent().get_node_or_null("aimAssist") != null:
			grapplingHookChild.positionToReach = to_local(get_parent().get_node("aimAssist").position)
		else:
			grapplingHookChild.positionToReach = get_local_mouse_position()
		grapplingHookChild.position = get_global_transform().origin
		
		get_parent().add_child(grapplingHookChild)
	
	elif returnGrappling == true and  get_parent().get_node_or_null("Grappling") != null:
		get_parent().get_node("Grappling").endGrapple(position, delta)

	if get_local_mouse_position().x - to_local(position).x > 0:
		if rope.get_point_count() > 1:
			rope.remove_point(1)
		rope.add_point(to_local(get_parent().get_node("Grappling").position) + Vector2(0, -4))
	else:
		if rope.get_point_count() > 1:
			rope.remove_point(1)
		rope.add_point(to_local(get_parent().get_node("Grappling").position) + Vector2(0, 4))

# Grappling Max Range Return
func _on_max_grappling_range_area_exited(area):
	if get_parent().get_node_or_null("Grappling") != null:
		if area == get_parent().get_node("Grappling") and get_parent().get_node("Grappling").isMoving == true:
			returnGrappling = true
	pass # Replace with function body.

# mantling
func mantling():
	if grapplingActive:
		mantlingActive = false
	elif grapplingActive == false:
		if animation.animation != "right_mantling":
			animations("right_mantling")
		moveActive = false
		grapplingActive = false
		balancing = false
		littleDash = false
		target_velocity.x = move_toward(target_velocity.x, 0, SPEED)
		target_velocity.y = move_toward(0, 0, 0)
		
		if Input.is_action_just_pressed("Crouch"):
			canMantle = false
			moveActive = true
			mantlingActive = false
		
		if Input.is_action_just_pressed("Jump"):
			moveActive = true
			mantlingActive = false
			jumpHeight = position.y - 48
			jumping = true
			gravityVar = 0.5
			coyoteTime = -1
			jumpBuffering = false
	
	pass

func hanging():
	target_velocity.x = move_toward(0,0,0)
	
	if animation.animation != "right_hanging" or animation.animation != "left_hanging":
		if animation.animation.begins_with("right"):
			animations("right_hanging")
		elif animation.animation.begins_with("left"):
			animations("left_hanging")
	
	
	moveActive = false
	mantlingActive = false
	jumping = false
	grapplingActive = false
	target_velocity.y = move_toward(0, 0, 0)
	
	if Input.is_action_just_pressed("Jump"):
		balancing = true
		canMantle = true
	
	if Input.is_action_just_released("GrapplingHook"):
		moveActive = true
		hangingActive = false
	
	if Input.is_action_just_pressed("MoveLeft"):
		animations("left_hanging")
	elif Input.is_action_just_pressed("MoveRight"):
		animations("right_hanging")
	
	pass

func useItem():
	pass

func dead():
	grapplingActive = false
	moveActive = false
	mantlingActive = false
	hangingActive = false
	target_velocity.y = move_toward(0, 0, 0)
	target_velocity.x = move_toward(0, 0, 0)
	dashUses = 0

func damage():
	if damageInvencibility <= 0:
		audios.hurt.play()
		if get_parent().get_node_or_null("Grappling") != null:
			get_parent().get_node("Grappling").position = position
		moveActive = true
		get_parent().get_node("Camera/CanvasLayer/GameUI").decreaseHealth()
		damageInvencibility = 0.8
		target_velocity = Vector2(0, -300)
		set_collision_layer_value(5, false)

func animations(type):
	if damageInvencibility > 0:
		if animation.animation.begins_with("left"):
			animation.play("left_damage")
		else:
			animation.play("right_damage")
	else:
		animation.play(type)
	
	if type == "right_hanging" and balancing == false:
		animation.frame = 0
		animation.pause()
	elif type == "left_hanging" and balancing == false:
		animation.frame = 0
		animation.pause()


	pass # Replace with function body.


# Power Ups Activation
func doubleJumpActivation():
	doubleJumpUpgrade = true

func dashActivation():
	dashUpgrade = true

# Power Ups Uses
func useDash(delta):
	
	if dashTime > 0:
		dashTime -= delta
		target_velocity = get_local_mouse_position().normalized() * 1000
		canMantle = false
	elif dashTime < 0:
		dashTime = 0
		canMantle = true
		target_velocity.y = move_toward(0, 0, 0)


func decreaseDifficulty():
	difficulty += 1

	if difficulty == 1:
		aimAssistActive = false
		if get_parent().get_node_or_null("aimAssistArea") != null:
			get_parent().get_node_or_null("aimAssistArea").queue_free()
		if get_parent().get_node_or_null("aimAssist") != null:
			get_parent().get_node_or_null("aimAssist").free()
	elif difficulty == 2:
		hookPathActive = false
	elif difficulty > 2:
		difficulty = 0
		hookPathActive = true
		aimAssistActive = true

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"difficulty" : difficulty,
		"doubleJumpUpgrade" : doubleJumpUpgrade,
		"dashUpgrade" : dashUpgrade,
		"currentHealth" : currentHealth,
		"maxHealth" : maxHealth
	}
	return save_dict

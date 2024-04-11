extends CharacterBody2D


@onready var jumpBufferingCast = $jumpBufferingCast

@onready var animation = $AnimatedSprite2D
@onready var afterImageParticles = $AfterimageParticles
@onready var dashStartParticles = $DashStartParticles
@onready var dashParticles = $DashParticles

# Mouse Follower
@onready var mouseFollower = $Aim_Assist
@onready var rope = $Rope

# Mouse position tracker
var cursorXcoord

# Movement variables
var moveActive : bool = true
var grapplingActive : bool = false
var mantlingActive : bool = false
var deadActive : bool = false
var dashActive : bool = false

var staticActive := false

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
@export var dashVelocity : float = 1000
@export var dashDuration : float = 0.3
var dashTime : float = 0.0
var dashUses : int = 1
var dashDirection := 0

# Damage
var takingDamage = false
var hookPathActive : bool = true
var aimAssistActive : bool = true
# Get gravity
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Damage
var damageInvincibility := 0.0

# Difficulty
var difficulty := 0

# Health
var currentHealth := 3
var maxHealth := 3

# Power Ups Activation
var doubleJumpUpgrade : bool = false
var dashUpgrade : bool = false

# Sounds
var audios

func _ready():
	grapplingHookProjectile = preload(GlobalPaths.GRAPPLING_HOOK_PATH)
	audios = get_node("Audios")

func _physics_process(delta):
	cursorXcoord = (to_local(position) - get_local_mouse_position()).normalized().x
	
	if jumpHolding == true:
		jumpTimer += delta
	
	velocity = target_velocity
	
	# Movements
	if staticActive:
		moveActive = false
		grapplingActive = false
		mantlingActive = false
		deadActive = false
		dashActive = false
		target_velocity.x = move_toward(0,0,0)
		animations("idle", " ")
		if not is_on_floor():
			target_velocity.y += gravity * delta * gravityVar
	if moveActive:
		walk(delta)
	if grapplingActive:
		grappling(delta)
		canMantle = false
		moveActive = false
	if mantlingActive:
		mantling()
	if deadActive:
		dead()
	if hangingActive:
		hanging()
	if  balancing == true:
		var direction = 0
		
		animations("hanging", " ")
		
		if cursorXcoord <= 0:
			direction = 1
		elif cursorXcoord > 0:
			direction = -1


		hangingActive = false
		balancing = false
		littleDash = true
		target_velocity.x = 200 * direction
		target_velocity.y = -200
		moveActive = true
	
	# Fall Animation
	if jumping == false and is_on_floor() == false and animation.animation != "right_mantling" and hangingActive == false:
		animations("fall", " ")
	
	# Damage
	if takingDamage:
		damage()
	
	# Power Ups
	if dashActive:
		useDash(delta)

	move_and_slide()

	# Body Collision
	
	
	if damageInvincibility > 0:
		damageInvincibility -= delta
	else:
		set_collision_layer_value(5, true)
	
	mouseFollower.position = get_local_mouse_position()


func _process(_delta):
	if Input.is_action_just_pressed("GrapplingHook") and get_parent().get_node_or_null("Grappling") == null and mantlingActive == false and hangingActive == false and deadActive == false and dashTime == 0 and staticActive == false:
		grapplingActive = true
		moveActive = false
		jumping = false
		gravityVar = 0.75
	
	if Input.is_action_just_pressed("Dash") and dashUpgrade == true and dashUses > 0 and hangingActive == false and grapplingActive == false and mantlingActive == false:
		dashActive = true
		target_velocity = Vector2(0,0)
		littleDash = false

		dashTime = dashDuration

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
		
		if direction != 0:
			if jumping == false:
				if direction == 1:
					animations("running", "right")
				elif direction == -1:
					animations("running", "left")

	elif littleDash == false:
		target_velocity.x = move_toward(target_velocity.x, 0, SPEED)
		animations("idle", " ")
	
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
		if animation.animation != "right_jump" or animation.animation != "left_jump":
			animations("jump", " ")
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
			grapplingHookChild.positionToReach = to_local(get_parent().get_node("aimAssist").position) + Vector2(0, 8)
		else:
			grapplingHookChild.positionToReach = get_local_mouse_position()+ Vector2(0, 8)
			
		grapplingHookChild.position = get_node("AnimatedSprite2D/Node2D").get_global_transform().origin
		
		get_parent().add_child(grapplingHookChild)
	
	elif returnGrappling == true and  get_parent().get_node_or_null("Grappling") != null:
		get_parent().get_node("Grappling").endGrapple(delta)

	if get_local_mouse_position().x - to_local(position).x > 0:
		if rope.get_point_count() > 1:
			rope.remove_point(1)
		rope.add_point(to_local(get_parent().get_node("Grappling").position))# + Vector2(0, -4))
	else:
		if rope.get_point_count() > 1:
			rope.remove_point(1)
		rope.add_point(to_local(get_parent().get_node("Grappling").position))# + Vector2(0, 4))

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
			animations("mantling", " ")
		moveActive = false
		grapplingActive = false
		balancing = false
		littleDash = false
		target_velocity.x = move_toward(target_velocity.x, 0, SPEED)
		target_velocity.y = move_toward(0, 0, 0)
		
		if Input.is_action_just_pressed("Crouch"):
			moveActive = true
			mantlingActive = false
			canMantle = false
		
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
		animations("hanging", " ")
	
	
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
		
	animations("hanging", " ")
	
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
	if damageInvincibility <= 0:
		audios.hurt.play()
		if get_parent().get_node_or_null("Grappling") != null:
			get_parent().get_node("Grappling").position = position
		moveActive = true
		get_parent().get_node("Camera/CanvasLayer/GameUI").decreaseHealth()
		damageInvincibility = 0.8
		target_velocity = Vector2(0, -300)
		set_collision_layer_value(5, false)

func animations(type, directionX):
	var direction
	if cursorXcoord < 0 or type == "mantling":
		direction = "right_"
	else:
		direction = "left_"

	if directionX == "right":
		direction = "right_"
	elif directionX == "left":
		direction = "left_"
	
	if damageInvincibility > 0:
			animation.play(direction + "damage")
	elif dashActive and (animation.animation != "left_dash" or animation.animation != "right_dash"):
		if dashDirection == 1:
			animation.play("right_dash")
		else:
			animation.play("left_dash")
	
	elif get_parent().get_node_or_null("Grappling") != null:
		pass
	else:
		animation.play(direction + type)
	
	if type == "hanging" and balancing == false:
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
	if (get_local_mouse_position() - to_local(position)).x > 0 and dashDirection == 0:
		dashDirection = 1
	elif  dashDirection == 0:
		dashDirection = -1
	
	if dashTime > 0:
		dashTime -= delta
		target_velocity = Vector2(dashVelocity*dashDirection, 0)
		canMantle = false
		jumping = false	
		dashActive = true
		addAfterimageAndDashParticles()
		
	elif dashTime < 0:
		dashDirection = 0
		dashTime = 0
		canMantle = true
		dashActive = false
		
		afterImageParticles.emitting = false
		dashStartParticles.emitting = false
		dashParticles.emitting = false

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

func addAfterimageAndDashParticles():
	afterImageParticles.texture = animation.sprite_frames.get_frame_texture(animation.animation, animation.frame)
	if afterImageParticles.emitting == false :
			afterImageParticles.gravity.x = dashDirection * 200
			afterImageParticles.emitting = true
	
	if dashStartParticles.emitting == false :
		dashStartParticles.direction.x = dashDirection
		dashStartParticles.gravity.x = dashStartParticles.direction.x * 200
		dashStartParticles.emitting = true
	
	dashParticles.emitting = true


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

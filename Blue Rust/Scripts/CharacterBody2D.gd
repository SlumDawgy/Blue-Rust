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

var jumpHeight : float
var jump_target_velocity : float = -200.0
var jumping : bool = false
var gravityVar : float = 1

# Can mantle edge
var canMantle : bool = true

# Grappling Hook
var positionToReach : Vector2
var returnGrappling : bool = false
var grapplingHookProjectile
var hookPathActive : bool = true
var aimAssistActive : bool = true

var hangingActive : bool = false
var balancing : bool = false
var littleDash : bool = false

# Power Ups Activation
var doubleJumpUpgrade : bool = false
var dashUpgrade : bool = true

# Dash
var dashTime : float = 0.0
var dashUses : int = 1

# Damage
var takingDamage = false
# Get gravity
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Damage
var damageInvencibility = 0

func _ready():
	grapplingHookProjectile = preload("res://Scenes/Grappling.tscn")

func _physics_process(delta):
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
		animation.play("right_hanging")

		if animation.frame == 4:
			hangingActive = false
			moveActive = true
			balancing = false
		
			var direction
				
			if animation.flip_h == false:
					direction = 1
			else:
				direction = -1
			
			jumping = true
			littleDash = true
			target_velocity.x = 200 * direction
			target_velocity.y = -200
	
	# Fall Animation
	if jumping == false and is_on_floor() == false and animation.animation != "right_mantling" and hangingActive == false:
		if animation.animation.begins_with("right"):
			animation.play("right_fall")
		elif  animation.animation.begins_with("left"):
			animation.play("left_fall")
	
	# Damage
	if takingDamage:
		damage()
	
	# Power Ups
	useDash(delta)

	move_and_slide()

	# Body Collision
	damageInvencibility -= delta
	
	mouseFollower.position = get_local_mouse_position()


func _process(_delta):
	if Input.is_action_just_pressed("GrapplingHook") and get_parent().get_node_or_null("Grappling") == null and mantlingActive == false and hangingActive == false:
		grapplingActive = true
		moveActive = false
		jumping = false
		gravityVar = 1
	
	if Input.is_action_just_pressed("Dash") and dashUpgrade == true and dashUses > 0:
		dashTime = 0.2
		dashUses -= 1
	
	# Use Item
	if Input.is_action_just_pressed("useItem"):
		useItem()

# Walking / Running
func walk(delta):
	var direction = Input.get_axis("MoveLeft", "MoveRight")
	if direction and littleDash == false:
		target_velocity.x = direction * SPEED
		
		if direction == -1:
			if animation.animation != "left_running" and jumping == false:
				animations("left_running")
		else:
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
		dashUses = 1
		if target_velocity.y > 0:
			target_velocity.y = 0

		canMantle = true
		balancing = false
		littleDash = false
		if animation.animation == "right_fall":
			animations("right_idle")
		elif animation.animation == "left_fall":
			animations("left_idle")

	# Jump + Jump Buffering + Coyote Time + Double Jump
	if (Input.is_action_just_pressed("Jump") and coyoteTime > 0) or (jumpBuffering and is_on_floor()):
		jumpHeight = position.y - 32
		jumping = true
		gravityVar = 1
		coyoteTime = -1
		jumpBuffering = false
		jumpHolding = true
		
		if doubleJumpUpgrade == true:
			doubleJump = true
			jumpHeight -= 32
	
	elif doubleJump == true and Input.is_action_just_pressed("Jump") and is_on_floor() == false:
		jumpHeight = position.y - 48
		jumping = true
		gravityVar = 0.5
		coyoteTime = -1
		jumpBuffering = false
		doubleJump = false
		jumpHolding = true
	
	if (Input.is_action_pressed("Jump")) and jumping == true and position.y < jumpHeight + 8 and jumpHolding == true:
		jumpHeight -= 32
		jumpHolding = false
		
	
	if jumping == true:
		if animation.animation != "right_jump" and animation.animation.begins_with("right"):
			animation.play("right_jump")
			print(10)
		if animation.animation != "left_jump" and animation.animation.begins_with("left"):
			animation.play("left_jump")
		if position.y <= jumpHeight:
			jumping = false
			jumpHolding = false
			gravityVar = 1
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
			animation.play("right_mantling")
		moveActive = false
		grapplingActive = false
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
	
	if animation.animation != "right_hanging":
		animations("right_hanging")
	moveActive = false
	mantlingActive = false
	jumping = false
	grapplingActive = false
	target_velocity.y = move_toward(0, 0, 0)
	
	if Input.is_action_just_pressed("Jump"):
		balancing = true
	
	if Input.is_action_just_released("GrapplingHook"):
		moveActive = true
		hangingActive = false
	
	pass

func useItem():
	pass

func dead():
	grapplingActive = false
	moveActive = false
	mantlingActive = false
	target_velocity.y = move_toward(0, 0, 0)
	target_velocity.x = move_toward(0, 0, 0)
	dashUses = 0

func damage():
	if damageInvencibility < 0:
		target_velocity.x = move_toward(0,0,0)
		if get_parent().get_node_or_null("Grappling") != null:
			get_parent().get_node("Grappling").position = position
		
		moveActive = true
		get_parent().get_node("Camera/GameUI").decreaseHealth()
		damageInvencibility = 1
		target_velocity = Vector2(-700, -300)

func animations(type):
	animation.play(type)
		
	if type == "right_hanging" and balancing == false:
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
	
	if dashTime > 0 and grapplingActive == false:
		dashTime -= delta
		target_velocity = get_local_mouse_position().normalized() * 1000
	elif dashTime < 0:
		dashTime = 0
		target_velocity.y = move_toward(0, 0, 0)

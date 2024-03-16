extends CharacterBody2D

@onready var jumpBufferingCast = $RayCast2D2

@onready var checkWall = $checkWall
@onready var checkWallUp = $checkWallUp

@onready var checkWallLeft = $checkWallLeft
@onready var checkWallUpLeft = $checkWallUpLeft

@onready var rope = $Rope

@onready var maxRangePol = $MaxGrapplingRange/Polygon2D
@onready var hookPath = $HookPath

@onready var animation = $AnimatedSprite2D

# Mouse Follower
@onready var mouseFollower = $Mouse_Follower

# Movement variables
var moveActive : bool = true
var grapplingActive : bool = false
var hangingActive : bool = false
var deadActive : bool = false

# Speed
const SPEED : float = 115.0

# Aim Dots
var aim
var aiming

# Collision
var collision : Rect2

# Jump Variables
var coyoteTime : float = 0.01
var jumpBuffering : bool = false
var doubleJump : bool = false
var jumpHolding : bool = false

var jumpHeight : float
var jumpVelocity : float = -200.0
var jumping : bool = false
var gravityVar : float = 1

# Can mantle edge
var canHangle : bool = true

# Grappling Hook
var positionToReach : Vector2
var returnGrappling : bool = false
var grapplingHookProjectile
var hookPathActive : bool = true
var aimAssistActive : bool = true

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
	aim = preload("res://Assets/Aim.png")
	aiming = preload("res://Assets/Aiming.png")
	hookPath.add_point(to_local(position))

func _physics_process(delta):
	# Movements
	if moveActive:
		walk(delta)
	if grapplingActive:
		grappling(delta)
	if hangingActive:
		hanging()
	if deadActive:
		dead()
	
	# Damage
	if takingDamage:
		damage()
	
	# Power Ups
	useDash(delta)
	
	# Get Collision
	get_collision()
	
	# Mantle Edges
	checkingWall()
	
	# Start Movements

	move_and_slide()

	# Body Collision
	damageInvencibility -= delta
	
	# hook Path
	get_hookPath()
	
	mouseFollower.position = get_local_mouse_position()


func _process(delta):
	if Input.is_action_just_pressed("GrapplingHook") and get_parent().get_node("Grappling") == null and hangingActive == false:
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
	
	# Aim
	if Input.is_action_just_pressed('Aim'):
		maxRangePol.visible = true
		Input.set_custom_mouse_cursor(aiming, Input.get_current_cursor_shape(), Vector2(16,16))
		
		pass
	
	if Input.is_action_just_released("Aim"):
		maxRangePol.visible = false
		Input.set_custom_mouse_cursor(aim, Input.get_current_cursor_shape(), Vector2(16,16))
		pass

# Walking / Running
func walk(delta):
	var direction = Input.get_axis("MoveLeft", "MoveRight")
	if direction:
		velocity.x = direction * SPEED
		
		if direction == -1:
			animation.flip_h = true
			animations("running")
		else:
			animation.flip_h = false
			animations("running")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animations("default")
	
	# Add Jump Buffering
	if jumpBufferingCast.is_colliding() and Input.is_action_just_pressed("Jump"):
			jumpBuffering = true
	
	# Is On Floor activations
	if is_on_floor():
		coyoteTime = 0.5
		dashUses = 1
		canHangle = true

	# Jump + Jump Buffering + Coyote Time + Double Jump
	if (Input.is_action_just_pressed("Jump") and coyoteTime > 0) or (jumpBuffering and is_on_floor()):
		jumpHeight = position.y - 32
		jumping = true
		gravityVar = 0.5
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
		if position.y <= jumpHeight:
			jumping = false
			jumpHolding = false
			gravityVar = 1.5
			velocity.y = move_toward(0, velocity.y, SPEED)
		velocity.y = jumpVelocity
	
	if not is_on_floor():
		velocity.y += gravity * delta * gravityVar
		coyoteTime -= delta * 3

# Grappling
func grappling(delta):
	velocity.y = gravity * delta * 1.5
	
	var grapplingHookChild = grapplingHookProjectile.instantiate()
	var Pixels : int
	
	if Input.is_action_pressed('Aim') and grapplingHookChild.aim == false and is_on_floor():
		grapplingHookChild.aim = true
	
	if get_parent().get_node("Grappling") == null:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		
		var directionToPosition = (to_local(position) - get_local_mouse_position()).normalized()
		grapplingHookChild.rotation =  PI + atan2(directionToPosition.y, directionToPosition.x) 


		if get_parent().get_node("aimAssist") != null:
			grapplingHookChild.positionToReach = to_local(get_parent().get_node("aimAssist").position)
		else:
			grapplingHookChild.positionToReach = get_local_mouse_position()
		grapplingHookChild.position = get_global_transform().origin
		
		get_parent().add_child(grapplingHookChild)
	
	elif returnGrappling == true and  get_parent().get_node("Grappling") != null:
		get_parent().get_node("Grappling").endGrapple(position, delta)
	
	get_parent().get_node("Grappling").collision.position = to_local(get_parent().get_node("Grappling").position) + Vector2(-8, -8)
	get_parent().get_node("Grappling").collision.end = to_local(get_parent().get_node("Grappling").position) + Vector2(8, 8)

	if get_local_mouse_position().x - to_local(position).x > 0:
		rope.remove_point(2)
		rope.add_point(to_local(get_parent().get_node("Grappling").position) + Vector2(0, -4))
	else:
		rope.remove_point(2)
		rope.add_point(to_local(get_parent().get_node("Grappling").position) + Vector2(0, 4))


# Grappling Max Range Return
func _on_max_grappling_range_area_exited(area):
	if area == get_parent().get_node("Grappling") and get_parent().get_node("Grappling").isMoving == true:
		returnGrappling = true
	pass # Replace with function body.

# Hanging
func hanging():
	moveActive = false
	grapplingActive = false
	velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.y = move_toward(0, 0, 0)
	
	if Input.is_action_just_pressed("Crouch"):
		moveActive = true
		hangingActive = false
	
	if Input.is_action_just_pressed("Jump"):
		moveActive = true
		hangingActive = false
		jumpHeight = position.y - 48
		jumping = true
		gravityVar = 0.5
		coyoteTime = -1
		jumpBuffering = false
	
	pass

# get collision
func get_collision():
	collision.position = to_local(position) + Vector2(-16, -16)
	collision.end = to_local(position) + Vector2(16, 16)

# Power Ups Activation
func doubleJumpActivation():
	doubleJumpUpgrade = true

func dashActivation():
	dashUpgrade = true

# Power Ups Uses
func useDash(delta):
	
	if dashTime > 0 and grapplingActive == false:
		dashTime -= delta
		velocity = get_local_mouse_position().normalized() * 1000
	elif dashTime < 0:
		dashTime = 0
		velocity.y = move_toward(0, 0, 0)

func useItem():
	print(10)
	pass

func dead():
	grapplingActive = false
	moveActive = false
	hangingActive = false
	velocity.y = move_toward(0, 0, 0)
	velocity.x = move_toward(0, 0, 0)
	dashUses = 0


func _on_head_body_entered(body):
	jumping = false
	gravityVar = 1
	velocity.y = move_toward(0, velocity.y, SPEED)
	pass # Replace with function body.

func checkingWall():
	var collider
	var colliderLeft
	
	if checkWall.is_colliding() and is_on_floor() == false:
		collider = checkWall.get_collider()
	if checkWallLeft.is_colliding() and is_on_floor() == false:
		colliderLeft = checkWallLeft.get_collider()
	
	if collider != null:
		if collider.is_in_group("Tile"):
			if checkWallUp.is_colliding() == false and canHangle == true and jumping == false:
				hangingActive = true
				canHangle = false
	
	if colliderLeft != null:
		if colliderLeft.is_in_group("Tile"):
			if checkWallUpLeft.is_colliding() == false and canHangle == true and jumping == false:
				hangingActive = true
				canHangle = false


func damage():
	if damageInvencibility < 0:
		get_parent().get_node("Camera/GameUI").decreaseHealth()
		damageInvencibility = 1
		velocity = Vector2(-700, -300)



func _on_damage_collision_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	
	if body.is_in_group("Tile"):
		var coords = body.get_coords_for_body_rid(body_rid)
	# Find Grapplable Object and move Player
		if body.get_cell_tile_data(0, coords).get_custom_data("CollisionType") == "Water":
			takingDamage = true


func _on_damage_collision_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("Tile"):
		var coords = body.get_coords_for_body_rid(body_rid)
	# Find Grapplable Object and move Player
		if body.get_cell_tile_data(0, coords).get_custom_data("CollisionType") == "Water":
			takingDamage = false
	pass # Replace with function body.

func get_hookPath():
	if hookPathActive == true:
		hookPath.remove_point(1)
		if get_parent().get_node("Grappling") != null:
			print(10)
			hookPath.add_point(get_parent().get_node("Grappling").positionToReach.normalized() * 128)
		elif get_parent().get_node("aimAssist") != null:
			hookPath.add_point(to_local(get_parent().get_node("aimAssist").position).normalized() * 128)
		else:
			hookPath.add_point(get_local_mouse_position().normalized() * 128)
	else:
		hookPath.clear_points()

func animations(type):
	if jumping == true:
		animation.frame = 7
	else:
		animation.play(type)



func _on_mouse_follower_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if aimAssistActive == true:
		if body.is_in_group("Tile"):
			
			var coords = body.get_coords_for_body_rid(body_rid)
		# Find Grapplable Object and move Player
			if body.get_cell_tile_data(0, coords).get_custom_data("CollisionType") == "Grapple":
				if get_parent().get_node("aimAssist") != null:
					get_parent().get_node("aimAssist").position = body.map_to_local(coords)
				
				
				else:
				
					var aimAssist = Sprite2D.new()
					
					aimAssist.texture = aiming
					aimAssist.name = "aimAssist"
					aimAssist.position = body.map_to_local(coords)
					
					get_parent().add_child(aimAssist)
					
					var aimAssistArea = Area2D.new()
					aimAssistArea.name = "aimAssistArea"
					
					var aimAssistAreaCollision = CollisionShape2D.new()
					
					aimAssistAreaCollision.shape = CircleShape2D.new()
					aimAssistAreaCollision.shape.set_radius(32)
					
					aimAssistArea.connect("area_shape_exited", Callable(self, "_on_aimAssistArea_area_shape_exited"))
					aimAssistArea.position = body.map_to_local(coords)
					
					aimAssistArea.add_child(aimAssistAreaCollision)
					
					get_parent().add_child(aimAssistArea)

			

func _on_aimAssistArea_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if aimAssistActive == true:
		if area != null:
			if area.is_in_group("Mouse"):
				if get_parent().get_node("aimAssist") != null:
					get_parent().get_node("aimAssist").free()
			
				if get_parent().get_node("aimAssistArea") != null:
					aimAssistAreaFree()

func aimAssistAreaFree():
	get_parent().get_node("aimAssistArea").disconnect("_on_aimAssistArea_area_shape_exited", Callable(self, "_on_aimAssistArea_area_shape_exited"))
	get_parent().get_node("aimAssistArea").queue_free()

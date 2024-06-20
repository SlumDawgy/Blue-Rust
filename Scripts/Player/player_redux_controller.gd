extends CharacterBody2D
class_name Player

# TODO NEXT: grapple...

# Player Sprite Nodes
@onready var playerSprite = $PlayerSprite
@onready var armSprite = $PlayerSprite/Arm
@onready var aimSprite = $PlayerSprite/AimReticle

# Grappling Hook Scene Path
@onready var grapplingHookScene : PackedScene = preload(GlobalPaths.GRAPPLING_HOOK_PATH)

# Mantle Raycast Nodes
@onready var shoulderRaycast = $PlayerRaycasts/ShoulderRaycast
@onready var headRaycast = $PlayerRaycasts/HeadRaycast
@onready var raycastLength : float = 11.5

# Dash Nodes
@onready var afterImageParticles : CPUParticles2D = $DashEffects/AfterimageParticles
@onready var dashStartParticles : CPUParticles2D = $DashEffects/DashStartParticles
@onready var dashParticles : CPUParticles2D = $DashEffects/DashParticles

# Timer Nodes
@onready var mantle_timer : Timer = $Timers/MantleTimer

# Player Exports
@export_category("Player Movement")
@export var run_speed : float = 150.0
@export var jump_height : float = -600.0
@export var max_jumps : int = 1
@export var dash_enabled : bool = false
@export var dash_speed : float = 400.0

@export_category("Player Aim")
@export var aim_radius : float = 64.0

@export_group("")



# Enum to define States
enum {
	STATE_IDLE,
	STATE_RUN,
	STATE_JUMP,
	STATE_FALL,
	STATE_MANTLING,
	STATE_HANGING,
	STATE_DASHING,
	STATE_GLIDING,
	STATE_DAMAGE,
	STATE_DYING
}

# Physics "Constants"
var GRAVITY : float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Player State and Postion variables
var state = STATE_IDLE
var direction : int = 1
var can_mantle : bool = true
var jump_count : int  = 1
var coyote_timeout : bool = false
var coyote_y_velocity_limit : float = 100.0
var aim_vector : Vector2 = Vector2.ZERO
var grappling : bool = false
var grappling_hook

# This is all just style, delete if dumb
var aim_reset_counter : int = 0
var aim_reset_counter_max : int = 100

# Player Control options
@export var mouseEnabled : bool = false
@export var controllerEnabled : bool = true


func _ready():
	playerSprite.play("right_idle")
	mantle_timer.connect("timeout", _on_mantle_timer_timeout)

func _physics_process(delta):
	if is_on_floor():
		velocity.y = 0.0
		jump_count = 1
		coyote_timeout = false
	
	handle_state()
	if grappling:
		handle_grapple(delta)
	else:
		handle_directional_input()
		handle_aim_input()
		handle_grapple_input()
		handle_jump_input()
		
	set_y_velocity(delta)
	adjust_arm_pivot()
	move_and_slide()
	
func handle_directional_input():
	## Used to determine what changes in physics need to be applied
	## based on the current inputs from the player
	var move_left = Input.is_action_pressed("MoveLeft")
	var move_right = Input.is_action_pressed("MoveRight")

	if state == STATE_DASHING:
		pass
	elif move_left and move_right:
		velocity.x = 0.0
	elif move_right:
		velocity.x = lerp(velocity.x, run_speed, 0.25) 
	elif move_left:
		velocity.x = lerp(velocity.x, -1.0 * run_speed, 0.25)
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.25) 
	
func handle_jump_input():
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			jump_count += 1
			coyote_timeout = true
			velocity.y = lerp(jump_height, 0.0, 0.25)
		elif state==STATE_MANTLING:
			# Trigger state based jumps before !is_on_floor jumps
			jump_count += 1
			coyote_timeout = true # So that if you exit mantle you can recover at Coyote speed too
			velocity.y = lerp(jump_height, 0.0, 0.25)
		elif !is_on_floor() and jump_count <= max_jumps:
			jump_count += 1
			velocity.y = lerp(jump_height, 0.0, 0.25)
	elif Input.is_action_just_released("Jump") and velocity.y < 0:
		# Allows player to release jump and smoothly stop going up
		velocity.y = lerp(velocity.y, 0.0, 0.5)
	elif velocity.y > coyote_y_velocity_limit and !coyote_timeout:
		jump_count += 1
		coyote_timeout = true

func handle_grapple_input():
	if (Input.is_action_just_pressed("GrapplingHook") 
		and state != STATE_DASHING 
		and state != STATE_DAMAGE):
			
		grappling_hook = grapplingHookScene.instantiate()
		owner.add_child(grappling_hook)
		grappling_hook.transform = armSprite.global_transform
		grappling = true
		
		if is_on_floor():
			print('here')
			change_state(STATE_IDLE, direction)
			
		velocity = Vector2.ZERO
		return grappling_hook
	return
		
func handle_aim_input():
	if mouseEnabled and !controllerEnabled:
		aim_vector = get_local_mouse_position()
	elif controllerEnabled:
		aim_vector = Input.get_vector("Aim_Left","Aim_Right","Aim_Up","Aim_Down")
		aim_vector *= aim_radius

	if aim_vector == Vector2.ZERO:
		aimSprite.visible=false
		aim_reset_counter += 1
		if aim_reset_counter == aim_reset_counter_max:
			armSprite.look_at(to_global(Vector2.ZERO))
			aim_reset_counter = 0
	else:
		aimSprite.visible=true
		aimSprite.position = aim_vector
		armSprite.look_at(to_global(aim_vector))
		aim_reset_counter = 0

func handle_grapple(delta):
	if !is_instance_valid(grappling_hook):
		grappling = false
		return
	
	if grappling_hook.attached:
		position += grappling_hook.transform.x * delta * grappling_hook.max_speed
		change_state(STATE_JUMP, direction)
	else:
		state = STATE_IDLE
		
func set_y_velocity(delta):
	if grappling:
		if !grappling_hook.attached:
			velocity.y += GRAVITY/75.0 * delta
	elif state == STATE_MANTLING:
		jump_count = 1
		coyote_timeout = false
		velocity = Vector2.ZERO
	elif state == STATE_HANGING:
		jump_count = 1
		coyote_timeout = false
		velocity = Vector2.ZERO
	else:
		velocity.y += GRAVITY * delta

func handle_state():
	## Used to determine if there is a change in input or physics while in a state
	## what state to transition to next
	var move_left = Input.is_action_pressed("MoveLeft")
	var move_right = Input.is_action_pressed("MoveRight")
	
	var new_direction : int = direction
	if velocity.x < 0.0:
		new_direction = -1
	elif velocity.x > 0.0:
		new_direction = 1
			
	match state:
		STATE_IDLE:
			if Input.is_action_just_pressed("Jump") and !grappling:
				change_state(STATE_JUMP, new_direction)
			elif !is_on_floor():
				change_state(STATE_FALL, new_direction)
			elif move_left and move_right:
				pass
			elif (move_left or move_right) and !grappling:
				change_state(STATE_RUN, new_direction)
			elif Input.is_action_just_pressed("Dash") and dash_enabled and !grappling:
				change_state(STATE_DASHING, new_direction)

		STATE_RUN:
			if !is_on_floor():
				change_state(STATE_FALL, new_direction)
			elif move_right == move_left:
				change_state(STATE_IDLE, new_direction)
			elif Input.is_action_just_pressed("Jump") and !grappling:
				change_state(STATE_JUMP, new_direction)
			elif Input.is_action_just_pressed("Dash") and dash_enabled and !grappling:
				change_state(STATE_DASHING, new_direction)
			elif move_right or move_left:
				change_state(STATE_RUN, new_direction)
			elif !move_right or !move_left:
				change_state(STATE_IDLE, new_direction)
			elif direction != new_direction:
				change_state(STATE_RUN, new_direction)

				
		STATE_JUMP:
			if is_on_floor(): # In case a platform rises up and catches you?
				change_state(STATE_IDLE, new_direction)
			if !is_on_floor() and velocity.y > 0.0:
				change_state(STATE_FALL, new_direction)
			elif direction != new_direction:
				change_state(STATE_JUMP, new_direction)
			elif Input.is_action_just_pressed("Dash") and dash_enabled and !grappling:
				change_state(STATE_DASHING, new_direction)
			mantle_check()
				
		STATE_FALL:
			if is_on_floor():
				change_state(STATE_IDLE, new_direction)
			elif direction != new_direction:
				change_state(STATE_FALL, new_direction)
			elif Input.is_action_just_pressed("Dash") and dash_enabled and !grappling:
				change_state(STATE_DASHING, new_direction)
			elif Input.is_action_just_pressed("Jump") and jump_count <= max_jumps and !grappling:
				change_state(STATE_JUMP, new_direction)
			mantle_check()

		STATE_MANTLING:
			if Input.is_action_just_pressed("Dash") and dash_enabled:
				can_mantle = false
				mantle_timer.start()
				change_state(STATE_DASHING, new_direction * -1.0)
			elif Input.is_action_just_pressed("Jump"):
				can_mantle = false
				mantle_timer.start()
				change_state(STATE_JUMP, new_direction)
			elif Input.is_action_just_pressed("Crouch"):
				can_mantle = false
				mantle_timer.start()
				change_state(STATE_FALL, direction)
			
		STATE_HANGING:
			velocity = Vector2.ZERO
			if direction != new_direction:
				change_state(STATE_HANGING, new_direction)
			elif Input.is_action_just_pressed("Jump") and !grappling:
				change_state(STATE_JUMP, new_direction)
			elif Input.is_action_just_pressed("Dash") and dash_enabled and !grappling:
				change_state(STATE_DASHING, new_direction)
			elif Input.is_action_just_pressed("Crouch") and !grappling:
				change_state(STATE_FALL, direction)
				
		STATE_DASHING:
			if "dash" in playerSprite.get_animation() and playerSprite.get_frame_progress() < 1.0:
				velocity.x = lerp(velocity.x, direction * dash_speed, 0.25) 
				emit_dash_particles()
			elif is_on_floor():
				change_state(STATE_IDLE, new_direction)
			else:
				change_state(STATE_FALL, new_direction)

func change_state(new_state, new_direction):
	## Used for changing the animation and any directional 
	## properties of the player, ie, the raycast directions
	
	if state == new_state and direction == new_direction:
		return

	state = new_state
	direction = new_direction
	shoulderRaycast.target_position.x = direction * raycastLength
	headRaycast.target_position.x = direction * raycastLength
	
	var facing : String = "right_"
	if direction < 0:
		facing = "left_"

	match state:
		STATE_IDLE:
			playerSprite.play(facing + "idle")
		STATE_RUN:
			playerSprite.play(facing + "running")
		STATE_JUMP:
			playerSprite.play(facing + "jump")
		STATE_FALL:
			playerSprite.play(facing + "fall")
		STATE_MANTLING:
			playerSprite.play(facing + "mantling")
		STATE_HANGING:
			playerSprite.play(facing + "hanging")
		STATE_DASHING:
			playerSprite.play(facing + "dash")
		STATE_GLIDING:
			playerSprite.play(facing + "parasol_glide")
		STATE_DAMAGE:
			playerSprite.play(facing + "damage")
		STATE_DYING:
			playerSprite.play("death")

func mantle_check():
	if !is_on_floor() and can_mantle:
		if shoulderRaycast.is_colliding():
			if !headRaycast.is_colliding():
				var collider = shoulderRaycast.get_collider()
				if collider.is_class("TileMap"):
					var target_y = position.y + collider.local_to_map(position).y
					# This call deferred makes sure the player's location
					# and collision location are set before updating y pos
					call_deferred("_set_mantle_y_position", target_y)
					# Use change_state outside of handle_state sparingly
					# Ultimately this call should be traced back to
					# handle_state if correctly handled
					change_state(STATE_MANTLING, direction)

func emit_dash_particles():
	## Controls the styled effect for dashing
	
	afterImageParticles.texture = playerSprite.sprite_frames.get_frame_texture(
		playerSprite.animation, 
		playerSprite.frame
	)

	afterImageParticles.gravity.x = direction * 200
	afterImageParticles.emitting = true

	dashStartParticles.direction.x = direction
	dashStartParticles.gravity.x = dashStartParticles.direction.x * 200
	dashStartParticles.emitting = true

	dashParticles.emitting = true

func adjust_arm_pivot():
	## Used to map the arm pivot point to the correct
	## location on the player sprite depending on animation
	## Could be better suited to a script attached directly to the arm?
	
	var animation =  playerSprite.get_animation()
	var frame = playerSprite.get_frame()
	
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

	if "left_" in animation:
		armSprite.flip_v = true
		armSprite.z_index = -1
	else:
		armSprite.flip_v = false
		armSprite.z_index = 0

	if "hanging" in animation or "mantling" in animation or "death" in animation or "getting_up" in animation:
		armSprite.visible = false
	else:
		armSprite.visible = true

func _set_mantle_y_position(target_y):
	position.y = target_y

func _on_mantle_timer_timeout():
	can_mantle = true
	

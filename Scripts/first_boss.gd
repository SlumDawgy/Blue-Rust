extends CharacterBody2D

var player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation := $AnimatedSprite2D


@onready var wallCollisionLeft = $WallCollision/RayCast2D2
@onready var wallCollisionRight = $WallCollision/RayCast2D

var speed = 50
var chargeSpeed = 300

var isAttacking = false
var isMoving := true
var isTakingDamage := false
var isCharging := false
var isShooting := false
var isDying := false
var isStunned := false
var isSteam := false

var canDoDamage := false
var canReceiveDamage := false

var attackCD := 1.0
var chargeAttackCD := 5.0

var chargeCD := 1.0
var steamCD := 1.0

var health := 3
var healthState := ["FullHealth", "HalfHealth", "LowHealth"]
var healthStateCounter := 0

var stunCD := 3.0


@onready var audios = $Audios

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D/Node2D/AnimatedSprite2D.visible = false
	set_physics_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !is_instance_valid(player):
		player = get_tree().get_first_node_in_group("Player")
	else:
	
		if canReceiveDamage:
			$AnimatedSprite2D/Node2D/Aiming.visible = true
		else:
			$AnimatedSprite2D/Node2D/Aiming.visible = false
		
		attackCD -= delta
		chargeAttackCD -= delta
		
		if isStunned == false:
			stunCD = 3.0
		
		if isDying:
			die()
		elif isTakingDamage:
			damage()
		elif isStunned:
			stunned(delta)
		elif isMoving:
			move()
		elif isAttacking:
			attack()
		elif isCharging:
			charge(delta)
		elif isSteam:
			steam(delta)
		
		move_and_slide()

		if not is_on_floor():
			velocity.y += gravity * delta
		
		if canDoDamage == true and attackCD <= 0 and isCharging == false:
			isAttacking = true
			isMoving = false
		
		if abs(player.position.x - position.x) > 128 and chargeAttackCD < 0:
			isCharging = true
			isMoving = false
			isAttacking = false
		
		if Input.is_action_just_pressed("Crouch"):
			isDying = true


func attack():
	velocity.x = 0
	if animation.animation != (healthState[healthStateCounter] + "_Slash"):
		animation.play(healthState[healthStateCounter] + "_Slash")
		
	elif animation.animation == (healthState[healthStateCounter] + "_Slash"):
		if animation.frame == 1:
			$AnimatedSprite2D/Node2D/AnimatedSprite2D.play("default")
			$AnimatedSprite2D/Node2D/AnimatedSprite2D.visible = true
			if animation.flip_h == true:
				$AnimatedSprite2D/Node2D/AnimatedSprite2D.flip_v = true
				$AnimatedSprite2D/Node2D.rotation_degrees = 180
			else:
				$AnimatedSprite2D/Node2D/AnimatedSprite2D.flip_v = false
				$AnimatedSprite2D/Node2D.rotation_degrees = 0
		
		elif animation.frame == 3:
			isAttacking = false
			isMoving = true
			attackCD = 1
			$AnimatedSprite2D/Node2D/AnimatedSprite2D.visible = false
			if canDoDamage == true:
				player.damage()

func move():
	
	if ((position.x < player.position.x + 21 and position.x > player.position.x + 17 and animation.flip_h == true) or (position.x > player.position.x - 23 and position.x < player.position.x - 19 and animation.flip_h == false)) and player.hangingActive == true:
		isSteam = true
		isMoving = false
	elif position.x > player.position.x and player.hangingActive == false:
		velocity.x = -speed
		animation.flip_h = false
		$SteamParticles.position.x = 19
		animation.play(healthState[healthStateCounter] + "_Walk")
	elif position.x <= player.position.x and player.hangingActive == false:
		velocity.x = speed
		animation.flip_h = true
		$SteamParticles.position.x = -21
		animation.play(healthState[healthStateCounter] + "_Walk")

func charge(delta):
	if animation.animation != (healthState[healthStateCounter] + "_Charge"):
		animation.play(healthState[healthStateCounter] + "_Charge")
		velocity.x = 0
	
	elif animation.animation == (healthState[healthStateCounter] + "_Charge") && chargeCD > 0:
		chargeCD -= delta
	
	elif animation.animation == (healthState[healthStateCounter] + "_Charge") && chargeCD < 0:
		animation.frame = 1
		if audios.charge.playing == false:
			audios.charge.play()
		if animation.flip_h == false:
			velocity.x = -chargeSpeed
		elif animation.flip_h == true:
			velocity.x = chargeSpeed
	
	var colliderRight
	var colliderLeft
	
	if wallCollisionLeft.is_colliding():
		colliderLeft = wallCollisionLeft.get_collider()
	if wallCollisionRight.is_colliding():
		colliderRight = wallCollisionRight.get_collider()
		
	if colliderLeft != null:
		if colliderLeft.is_in_group("Tile") and velocity.x < 0:
			isCharging = false
			isStunned = true
			chargeAttackCD = 5
			chargeCD = 1
			audios.wallHit.play()
		elif colliderLeft.is_in_group("Player") and velocity.x < 0:
			player.damage()
			isCharging = false
			isMoving = true
			chargeAttackCD = 5
			attackCD = 2
			chargeCD = 1
	elif colliderRight != null:
		if  colliderRight.is_in_group("Tile") and velocity.x > 0:
			isCharging = false
			isStunned = true
			chargeAttackCD = 5
			chargeCD = 1
			audios.wallHit.play()
		elif colliderRight.is_in_group("Player") and velocity.x > 0:
			player.damage()
			isCharging = false
			isMoving = true
			chargeAttackCD = 5
			attackCD = 2
			chargeCD = 1
	pass

func stunned(delta):
	stunCD -= delta
	canReceiveDamage = true
	
	if animation.animation != (healthState[healthStateCounter] + "_Stunned") and stunCD > 0:
		animation.play(healthState[healthStateCounter] + "_Stunned")
	
	if stunCD < 0:
		
		if animation.animation != (healthState[healthStateCounter] + "_BackUp"):
			animation.play(healthState[healthStateCounter] + "_BackUp")
			audios.retrieve.play()
		
		elif animation.frame == 5:
			chargeAttackCD = 5.0
			isStunned = false
			isMoving = true
			canReceiveDamage = false

	pass

func damage():
	if animation.animation != (healthState[healthStateCounter] + "_Damage"):
		isMoving = false
		animation.play(healthState[healthStateCounter] + "_Damage")
		audios.bossHurt.play()
	
	if animation.frame == 2:
		animation.speed_scale *= 1.2
		speed *= 1.35
		chargeSpeed *= 1.35
		chargeCD -= 0.2
		health -= 1
		healthStateCounter += 1
		isTakingDamage = false
		isMoving = true
	
	if health == 0:
		animation.speed_scale = 1
		isDying = true
	
	pass

func steam(delta):
	if animation.animation != (healthState[healthStateCounter] + "_Steam"):
		isMoving = false
		animation.play(healthState[healthStateCounter] + "_Steam")
		velocity.x = 0
		$SteamParticles/CPUParticles2D.emitting = true
		
	steamCD -= delta
	
	if steamCD < 0.0:
		$SteamParticles.emitting = true
		if $SteamParticles/Area2D/CollisionShape2D.shape.b.y > -100:
			$SteamParticles/Area2D/CollisionShape2D.shape.b.y -= 100 * delta

	if player.hangingActive == false:
		$SteamParticles/CPUParticles2D.emitting = false
		$SteamParticles.emitting = false
		isSteam = false
		isMoving = true
		steamCD = 1.0
		$SteamParticles/Area2D/CollisionShape2D.shape.b.y = 0
	
func die():
	animation.play("Death")
	velocity.x = 0
	if animation.frame == 1:
			if audios.bossDie.playing == false:
				audios.bossDie.play()
			$"../AudioStreamPlayer".playing = true
			$"../BossFight".playing = false
	elif animation.frame == 2:
		$"../Label3".visible = true
		$"../PrisonTiles".set_cell(0, Vector2i(90, -66), -1)
		$"../PrisonTiles".set_cell(0, Vector2i(90, -67), -1)
		$"../PrisonTiles".set_cell(0, Vector2i(90, -68), -1)
		var powerUp = Area2D.new()
		var powerUpCollision = CollisionShape2D.new()
		var powerUpCollisionShape = RectangleShape2D.new()
		var powerUpSprite = AnimatedSprite2D.new()
		powerUpSprite.sprite_frames = load("res://PowerUpSpriteSheet.tres")
		powerUpSprite.speed_scale = 2
		powerUpSprite.play("default")
		
		powerUpCollision.shape = powerUpCollisionShape
		powerUpCollision.shape.size = Vector2(16, 16)
		
		powerUp.add_child(powerUpCollision)
		powerUp.add_child(powerUpSprite)

		powerUp.connect("body_entered", Callable(get_tree().root.get_node("Node2D"), "PowerUp"), 4)
		
		powerUp.position = position
		powerUp.name = "powerUp"
		
		get_tree().root.get_node("Node2D").add_child(powerUp)
		print(powerUp.body_entered.get_connections())
		
		queue_free()
		
	pass


func _on_area_2d_body_entered(body : CharacterBody2D):
	if body.is_in_group("Player"):
		canDoDamage = true
	pass # Replace with function body.


func _on_area_2d_body_exited(body : CharacterBody2D):
	if body.is_in_group("Player"):
		canDoDamage = false
	pass # Replace with function body.


func _on_area_2d_2_body_entered(body : CharacterBody2D):
	if is_instance_valid(player):
		if body.is_in_group("Player"):
			player.damage()
		if player.hangingActive == true:
			player.hangingActive = false
			player.moveActive = true
	pass # Replace with function body.



func _on_damagable_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if area.is_in_group("Grappling") and canReceiveDamage:
		isTakingDamage = true
		$AnimatedSprite2D/Node2D/GPUParticles2D.emitting = true
		canReceiveDamage = false
		isStunned = false
		isMoving = true
		
	pass # Replace with function body.

extends CharacterBody2D
class_name Enemy

var currentMovement : int
var healthState : Array = ["FullHealth", "HalfHealth", "LowHealth"]
var healthStateCounter : int = 0

@onready var bossSize : Vector2 = $HitBoxComponent/CollisionShape2D.shape.size
@onready var animation : AnimatedSprite2D = $FirstBossSprites

var speed : float = 50.0

# Charge Attack
var chargeSpeed : float = 300.0
@onready var wallCollisionLeft = $WallCollision/Left
@onready var wallCollisionRight = $WallCollision/Right

# Steam Attack
@onready var steamChargingParticles = $SteamParticles/Charging
@onready var steamAttackParticles = $SteamParticles

# Player
@export var player : Player


@onready var audios = $Audios

enum movement
{
	starting,
	enabled,
	attacking,
	charging,
	chargeAttacking,
	chargingSteam,
	steamAttacking,
	stunned,
	leavingStun,
	takingDamage,
	dying
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#$AnimatedSprite2D/Node2D/AnimatedSprite2D.visible = false
	currentMovement = movement.chargingSteam
	pass # Replace with function body.

func starting():
	pass

func enabled():
	if position.x - bossSize.x >= player.position.x and player.currentMovement != player.movement.hanging:
		velocity.x = -speed
		animation.flip_h = false
		$SteamParticles.position.x = 19
	elif position.x + bossSize.x < player.position.x and player.currentMovement != player.movement.hanging:
		velocity.x = speed
		animation.flip_h = true
		$SteamParticles.position.x = -21

func attack():
	pass
	
func charging():
	velocity.x = move_toward(0,0,0)
	await get_tree().create_timer(2).timeout
	currentMovement = movement.chargeAttacking

func chargeAttacking():
	if animation.flip_h:
		velocity.x = chargeSpeed
		if wallCollisionRight.is_colliding():
			currentMovement = movement.stunned
			position.x = wallCollisionLeft.get_collision_point().x - 38
	else:
		velocity.x = -chargeSpeed
		if wallCollisionLeft.is_colliding():
			currentMovement = movement.stunned
			position.x = wallCollisionLeft.get_collision_point().x + 38

func stunned():
	velocity.x = move_toward(0,0,0)
	await get_tree().create_timer(2.5).timeout
	currentMovement = movement.leavingStun

func chargingSteam():
	velocity.x = move_toward(0,0,0)
	steamChargingParticles.emitting = true
	await get_tree().create_timer(2.5).timeout
	currentMovement = movement.steamAttacking

func steamAttacking():
	steamAttackParticles.emitting = true
	if player.currentMovement != player.movement.hanging:
		steamAttackParticles.emitting = false
		steamChargingParticles.emitting = false
		await get_tree().create_timer(1).timeout
		currentMovement = movement.enabled
	pass

func takingDamage():
	velocity.x = move_toward(0,0,0)
	steamAttackParticles.emitting = false
	steamChargingParticles.emitting = false
	if animation.is_playing() == false:
		healthStateCounter += 1
		if healthStateCounter == 3:
			currentMovement = movement.dying
		else:
			currentMovement = movement.enabled

func dying():
	if animation.animation != "Death":
		animation.play("Death")
	velocity.x = 0
	if animation.frame == 1:
			if audios.bossDie.playing == false:
				audios.bossDie.play()
			$"../AudioStreamPlayer".playing = true
			$"../BossFight".playing = false

	if audios.bossDie.playing == false:
		await get_tree().create_timer(2).timeout
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
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("Crouch"):
		currentMovement = movement.takingDamage
	match currentMovement:
		movement.starting:
			pass
		movement.enabled:
			enabled()
		movement.attacking:
			pass
		movement.charging:
			charging()
		movement.chargeAttacking:
			chargeAttacking()
		movement.chargingSteam:
			chargingSteam()
		movement.steamAttacking:
			steamAttacking()
		movement.stunned:
			stunned()
		#movement.leavingStun: Already in the Animation Script
			#pass
		movement.takingDamage:
			takingDamage()
		movement.dying:
			dying()
	
	move_and_slide()
	
	
	#if canReceiveDamage:
		#$AnimatedSprite2D/Node2D/Aiming.visible = true
	#else:
		#$AnimatedSprite2D/Node2D/Aiming.visible = false
	#
	#attackCD -= delta
	#chargeAttackCD -= delta
	#
	#if isStunned == false:
		#stunCD = 3.0
	#
	#if isDying:
		#die()
	#elif isTakingDamage:
		#damage()
	#elif isStunned:
		#stunned(delta)
	#elif isMoving:
		#move()
	#elif isAttacking:
		#attack()
	#elif isCharging:
		#charge(delta)
	#elif isSteam:
		#steam(delta)
	#
	#move_and_slide()
#
	#if not is_on_floor():
		#velocity.y += gravity * delta
	#
	#if canDoDamage == true and attackCD <= 0 and isCharging == false:
		#isAttacking = true
		#isMoving = false
	#
	#if abs(player.position.x - position.x) > 128 and chargeAttackCD < 0:
		#isCharging = true
		#isMoving = false
		#isAttacking = false
	#
	#if Input.is_action_just_pressed("Crouch"):
		#isDying = true
#
#
#func attack():
	#velocity.x = 0
	#if animation.animation != (healthState[healthStateCounter] + "_Slash"):
		#animation.play(healthState[healthStateCounter] + "_Slash")
		#
	#elif animation.animation == (healthState[healthStateCounter] + "_Slash"):
		#if animation.frame == 1:
			#$AnimatedSprite2D/Node2D/AnimatedSprite2D.play("default")
			#$AnimatedSprite2D/Node2D/AnimatedSprite2D.visible = true
			#if animation.flip_h == true:
				#$AnimatedSprite2D/Node2D/AnimatedSprite2D.flip_v = true
				#$AnimatedSprite2D/Node2D.rotation_degrees = 180
			#else:
				#$AnimatedSprite2D/Node2D/AnimatedSprite2D.flip_v = false
				#$AnimatedSprite2D/Node2D.rotation_degrees = 0
		#
		#elif animation.frame == 3:
			#isAttacking = false
			#isMoving = true
			#attackCD = 1
			#$AnimatedSprite2D/Node2D/AnimatedSprite2D.visible = false
			#if canDoDamage == true:
				#player.currentMovement = player.movement.takingDamage
				#canDoDamage = false
#
#func move():
	#
	#if ((position.x < player.position.x + 21 and position.x > player.position.x + 17 and animation.flip_h == true) or (position.x > player.position.x - 23 and position.x < player.position.x - 19 and animation.flip_h == false)) and player.currentMovement == player.movement.hanging:
		#isSteam = true
		#isMoving = false
	#elif position.x > player.position.x and player.currentMovement != player.movement.hanging:
		#velocity.x = -speed
		#animation.flip_h = false
		#$SteamParticles.position.x = 19
		#animation.play(healthState[healthStateCounter] + "_Walk")
	#elif position.x <= player.position.x and player.currentMovement != player.movement.hanging:
		#velocity.x = speed
		#animation.flip_h = true
		#$SteamParticles.position.x = -21
		#animation.play(healthState[healthStateCounter] + "_Walk")
#
#func charge(delta):
	#if animation.animation != (healthState[healthStateCounter] + "_Charge"):
		#animation.play(healthState[healthStateCounter] + "_Charge")
		#velocity.x = 0
	#
	#elif animation.animation == (healthState[healthStateCounter] + "_Charge") && chargeCD > 0:
		#chargeCD -= delta
	#
	#elif animation.animation == (healthState[healthStateCounter] + "_Charge") && chargeCD < 0:
		#animation.frame = 1
		#if audios.charge.playing == false:
			#audios.charge.play()
		#if animation.flip_h == false:
			#velocity.x = -chargeSpeed
		#elif animation.flip_h == true:
			#velocity.x = chargeSpeed
	#
	#var colliderRight
	#var colliderLeft
	#
	#if wallCollisionLeft.is_colliding():
		#colliderLeft = wallCollisionLeft.get_collider()
	#if wallCollisionRight.is_colliding():
		#colliderRight = wallCollisionRight.get_collider()
		#
	#if colliderLeft != null:
		#if colliderLeft.is_in_group("Tile") and velocity.x < 0:
			#isCharging = false
			#isStunned = true
			#chargeAttackCD = 5
			#chargeCD = 1
			#audios.wallHit.play()
		#elif colliderLeft.is_in_group("Player") and velocity.x < 0:
			#player.currentMovement = player.movement.takingDamage
			#isCharging = false
			#isMoving = true
			#chargeAttackCD = 5
			#attackCD = 2
			#chargeCD = 1
	#elif colliderRight != null:
		#if  colliderRight.is_in_group("Tile") and velocity.x > 0:
			#isCharging = false
			#isStunned = true
			#chargeAttackCD = 5
			#chargeCD = 1
			#audios.wallHit.play()
		#elif colliderRight.is_in_group("Player") and velocity.x > 0:
			#player.currentMovement = player.movement.takingDamage
			#isCharging = false
			#isMoving = true
			#chargeAttackCD = 5
			#attackCD = 2
			#chargeCD = 1
	#pass
#
#func stunned(delta):
	#stunCD -= delta
	#canReceiveDamage = true
	#
	#if animation.animation != (healthState[healthStateCounter] + "_Stunned") and stunCD > 0:
		#animation.play(healthState[healthStateCounter] + "_Stunned")
	#
	#if stunCD < 0:
		#
		#if animation.animation != (healthState[healthStateCounter] + "_BackUp"):
			#animation.play(healthState[healthStateCounter] + "_BackUp")
			#audios.retrieve.play()
		#
		#elif animation.frame == 5:
			#chargeAttackCD = 5.0
			#isStunned = false
			#isMoving = true
			#canReceiveDamage = false
#
	#pass
#
#func damage():
	#if animation.animation != (healthState[healthStateCounter] + "_Damage"):
		#isMoving = false
		#animation.play(healthState[healthStateCounter] + "_Damage")
		#audios.bossHurt.play()
	#
	#if animation.frame == 2:
		#animation.speed_scale *= 1.2
		#speed *= 1.35
		#chargeSpeed *= 1.35
		#chargeCD -= 0.2
		#health -= 1
		#healthStateCounter += 1
		#isTakingDamage = false
		#isMoving = true
	#
	#if health == 0:
		#animation.speed_scale = 1
		#isDying = true
	#
	#pass
#
#func steam(delta):
	#if animation.animation != (healthState[healthStateCounter] + "_Steam"):
		#isMoving = false
		#animation.play(healthState[healthStateCounter] + "_Steam")
		#velocity.x = 0
		#$SteamParticles/CPUParticles2D.emitting = true
		#
	#steamCD -= delta
	#
	#if steamCD < 0.0:
		#$SteamParticles.emitting = true
		#if $SteamParticles/Area2D/CollisionShape2D.shape.b.y > -100:
			#$SteamParticles/Area2D/CollisionShape2D.shape.b.y -= 100 * delta
#
	#if player.currentMovement == player.movement.hanging == false:
		#$SteamParticles/CPUParticles2D.emitting = false
		#$SteamParticles.emitting = false
		#isSteam = false
		#isMoving = true
		#steamCD = 1.0
		#$SteamParticles/Area2D/CollisionShape2D.shape.b.y = 0
	#
#func die():
	#animation.play("Death")
	#velocity.x = 0
	#if animation.frame == 1:
			#if audios.bossDie.playing == false:
				#audios.bossDie.play()
			#$"../AudioStreamPlayer".playing = true
			#$"../BossFight".playing = false
	#elif animation.frame == 2:
		#$"../PrisonTiles".set_cell(0, Vector2i(90, -66), -1)
		#$"../PrisonTiles".set_cell(0, Vector2i(90, -67), -1)
		#$"../PrisonTiles".set_cell(0, Vector2i(90, -68), -1)
		#var powerUp = Area2D.new()
		#var powerUpCollision = CollisionShape2D.new()
		#var powerUpCollisionShape = RectangleShape2D.new()
		#var powerUpSprite = AnimatedSprite2D.new()
		#powerUpSprite.sprite_frames = load("res://PowerUpSpriteSheet.tres")
		#powerUpSprite.speed_scale = 2
		#powerUpSprite.play("default")
		#
		#powerUpCollision.shape = powerUpCollisionShape
		#powerUpCollision.shape.size = Vector2(16, 16)
		#
		#powerUp.add_child(powerUpCollision)
		#powerUp.add_child(powerUpSprite)
#
		#powerUp.connect("body_entered", Callable(get_tree().root.get_node("Node2D"), "PowerUp"), 4)
		#
		#powerUp.position = position
		#powerUp.name = "powerUp"
		#
		#get_tree().root.get_node("Node2D").add_child(powerUp)
		#print(powerUp.body_entered.get_connections())
		#queue_free()
		#
	#pass
#
#func _on_damagable_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	#if area.is_in_group("Grappling") and canReceiveDamage:
		#isTakingDamage = true
		#$AnimatedSprite2D/Node2D/GPUParticles2D.emitting = true
		#canReceiveDamage = false
		#isStunned = false
		#isMoving = true
		#
	#pass # Replace with function body.
#
#
#func _on_area_2d_2_area_entered(area : HitBoxComponent):
	#player.currentMovement = player.movement.takingDamage
#
#
#func _on_area_2d_area_entered(area : HitBoxComponent):
	#canDoDamage = true
	#pass # Replace with function body.
#
#
#func _on_area_2d_area_exited(area: HitBoxComponent):
	#canDoDamage = false
	#pass # Replace with function body.

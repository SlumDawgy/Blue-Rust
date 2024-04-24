extends CharacterBody2D
class_name Enemy

var currentMovement : int
var healthState : Array = ["FullHealth", "HalfHealth", "LowHealth"]
var healthStateCounter : int = 0
var changeScale : bool = false

@onready var bossSize : Vector2 = $HitBoxComponent/HitBoxCollider.shape.size
@onready var animation : AnimatedSprite2D = $FirstBossSprites
@onready var damageParticles : GPUParticles2D = $FirstBossSprites/Node2D/DamageParticle

var speed : float = 50.0

# Charge Attack
var chargeSpeed : float = 300.0
@onready var wallCollisionLeft = $WallCollision/Left
@onready var chargeAttackTimer = $ChargeAttackTimer

# Steam Attack
@onready var steamChargingParticles = $SteamParticles/Charging
@onready var steamAttackParticles = $SteamParticles
@onready var steamCollision = $SteamParticles/Damage/CollisionShape2D

# Normal Attack
@onready var attackCollision = $Attack

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

class BasicAttack:
	var damage : int = 1
	var knockback : int = 15
	var direction : int = 1
	

# Called when the node enters the scene tree for the first time.
func _ready():
	#$AnimatedSprite2D/Node2D/AnimatedSprite2D.visible = false
	currentMovement = movement.enabled
	pass # Replace with function body.

func starting():
	pass
		
func enabled():
	steamChecking(movement.chargingSteam)
	if attackCollision.is_colliding():
		currentMovement = movement.attacking
	elif abs(position.x - player.position.x) >= 180 and chargeAttackTimer.is_stopped():
		currentMovement = movement.charging
	elif position.x - bossSize.x >= player.position.x:
		velocity.x = -speed
		if changeScale == true:
			scale.x *= -1
			changeScale = false
	elif position.x + bossSize.x < player.position.x:
		velocity.x = speed
		if changeScale == false:
			scale.x *= -1
			changeScale = true

func attack():
	velocity.x = move_toward(0,0,0)
	if animation.frame == 2:
		if attackCollision.is_colliding():
			var collision = attackCollision.get_collider(0)

			if collision is Player:
				var hitbox : HitBoxComponent = collision.get_node("HitBoxComponent")		
				var basicAttack = BasicAttack.new()
				var collision_direction = (collision.global_position - global_position).normalized()
				if collision_direction.x < 0:
					basicAttack.direction = -1
				hitbox.damage(basicAttack)
		
	await get_tree().create_timer(2.0).timeout
	currentMovement = movement.enabled

func charging():
	velocity.x = move_toward(0,0,0)
	await get_tree().create_timer(2).timeout
	currentMovement = movement.chargeAttacking

func chargeAttacking():
	if changeScale == true:
		velocity.x = chargeSpeed
		if wallCollisionLeft.is_colliding():
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
	chargeAttackTimer.start(5)

func chargingSteam():
	velocity.x = move_toward(0,0,0)
	steamChargingParticles.emitting = true
	await get_tree().create_timer(2.5).timeout
	
	steamChecking(movement.steamAttacking)

func steamAttacking():
	steamAttackParticles.emitting = true
	steamCollision.shape.a.y = -120
	if player.currentMovement != player.movement.hanging:
		steamAttackParticles.emitting = false
		steamChargingParticles.emitting = false
		steamCollision.shape.a.y = 0
		await get_tree().create_timer(1).timeout
		currentMovement = movement.enabled
	pass

func steamChecking(action):
	var checkPosition
	if changeScale == false:
		checkPosition = steamChargingParticles.to_local(position).x
	else:
		checkPosition = -steamChargingParticles.to_local(position).x
	
	if checkPosition >= player.to_local(position).x - 4 and checkPosition <= player.to_local(position).x + 4 and player.currentMovement == player.movement.hanging:
		currentMovement = action
	else:
		steamChargingParticles.emitting = false
		steamAttackParticles.emitting = false
		currentMovement = movement.enabled

func takingDamage():
	velocity.x = move_toward(0,0,0)
	steamAttackParticles.emitting = false
	steamChargingParticles.emitting = false
	damageParticles.emitting = true
	await get_tree().create_timer(2.0).timeout
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
func _physics_process(_delta):
	
	## PLAYTEST DEBUG 
	if Input.is_action_just_pressed("Crouch"):
		currentMovement = movement.takingDamage
	## PLAYTEST DEBUG
	match currentMovement:
		movement.starting:
			pass
		movement.enabled:
			enabled()
		movement.attacking:
			attack()
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

func _on_damage_body_entered(body : Player):
	var hitbox : HitBoxComponent = body.get_node("HitBoxComponent")		
	var basicAttack = BasicAttack.new()
	basicAttack.damage = 1
	var collision_direction = (body.global_position - global_position).normalized()
	if collision_direction.x < 0:
		basicAttack.direction = -1
	hitbox.damage(basicAttack)

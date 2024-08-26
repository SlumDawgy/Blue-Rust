extends CharacterBody2D
class_name Enemy

var currentMovement : int
var healthState : Array = ["FullHealth", "HalfHealth", "LowHealth"]
var healthStateCounter : int = 0
var changeScale : bool = false

@onready var bossSize : Vector2 = $HitBoxComponent/HitBoxCollider.shape.size
@onready var animation : AnimatedSprite2D = $FirstBossSprites
@onready var damageParticles : GPUParticles2D = $FirstBossSprites/Node2D/DamageParticle

var speed : float = 35.0

# Charge Attack
var chargeSpeed : float = 200.0
@onready var wallCollisionLeft = $WallCollision/Left
@onready var chargeAttackTimer = $ChargeAttackTimer
@onready var chargeHitBox = $ChargeHitBox

# Steam Attack
@onready var steamChargingParticles = $SteamParticles/Charging
@onready var steamAttackParticles = $SteamParticles
@onready var steamCollision = $SteamParticles/Damage/CollisionShape2D

# Normal Attack
@onready var attackCollision = $Attack

# Player
@export var player : Player
# Stunned
var canBeDamaged : bool = false
var stunnedTimer : float

# Power Up dropped on death 
var powerUpScene : PackedScene = preload(GlobalPaths.DASH_UPGRADE)

var awaitTimer : float = 0

var playedSound : bool = false
@onready var audios = $Audios

@onready var levelController = $"../.."

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
	var knockupwards : int = -250
	

func _ready():
	player = GlobalReferences.player
	currentMovement = movement.starting

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

func attack(delta):
	awaitTimer -= delta
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
	if awaitTimer < -2:
		currentMovement = movement.enabled
		awaitTimer = 0

func charging(delta):
	playSound(audios.charge)
	awaitTimer -= delta
	velocity.x = move_toward(0,0,0)
	if awaitTimer < -2:
		awaitTimer = 0
		playedSound = false
		currentMovement = movement.chargeAttacking

func chargeAttacking():
	if changeScale == true:
		velocity.x = chargeSpeed
		if wallCollisionLeft.is_colliding():
			
			AudioManager.play_sound(audios.wallHit)
			currentMovement = movement.stunned
			stunnedTimer = 2.5
			position.x = wallCollisionLeft.get_collision_point().x - 38
	else:
		velocity.x = -chargeSpeed
		if wallCollisionLeft.is_colliding():
			AudioManager.play_sound(audios.wallHit)
			currentMovement = movement.stunned
			stunnedTimer = 2.5
			position.x = wallCollisionLeft.get_collision_point().x + 38
	
	if chargeHitBox.is_colliding():
		var collision = attackCollision.get_collider(0)
		if collision is Player:
			var hitbox : HitBoxComponent = collision.get_node("HitBoxComponent")		
			var basicAttack = BasicAttack.new()
			var collision_direction = (collision.global_position - global_position).normalized()
			if collision_direction.x < 0:
				basicAttack.direction = -1
			hitbox.damage(basicAttack)

func stunned(delta):
	stunnedTimer -= delta
	velocity.x = move_toward(0,0,0)
	canBeDamaged = true
	$StunnedIndicator.visible = true
	if stunnedTimer < 0:
		canBeDamaged = false
		$StunnedIndicator.visible = false
		currentMovement = movement.leavingStun
		chargeAttackTimer.start(5)

func chargingSteam(delta):
	playSound(audios.charge)
	awaitTimer -= delta
	velocity.x = move_toward(0,0,0)
	steamChargingParticles.emitting = true
	canBeDamaged = true
	$StunnedIndicator.visible = true
	if awaitTimer < -2.5:
		playedSound = false
		awaitTimer = 0
		canBeDamaged = false
		$StunnedIndicator.visible = false
		steamChecking(movement.steamAttacking)

func steamAttacking(delta):
	playSound(audios.steam)
	awaitTimer -= delta
	steamAttackParticles.emitting = true
	steamCollision.shape.a.y = -120
	if player.currentMovement != player.movement.hanging:
		steamCollision.shape.a.y = 0
		if awaitTimer < -1:
			playedSound = false
			awaitTimer = 0
			steamAttackParticles.emitting = false
			steamChargingParticles.emitting = false
			currentMovement = movement.enabled

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

func takingDamage(delta):
	playSound(audios.bossHurt)
	awaitTimer -= delta
	velocity.x = move_toward(0,0,0)
	steamAttackParticles.emitting = false
	steamChargingParticles.emitting = false
	damageParticles.emitting = true
	$StunnedIndicator.visible = false
	if awaitTimer < -1:
		playedSound = false
		awaitTimer = 0
		currentMovement = movement.enabled
	
func dying(_delta):
	if animation.animation != "Death":
		animation.play("Death")
	velocity.x = 0
	if animation.frame == 1:
		AudioManager.play_Music(levelController.level_bgm)
		$Audios/Die.play()

	if animation.is_playing() == false:
		var powerUp = powerUpScene.instantiate()
		levelController.add_child(powerUp)
		powerUp.get_node("FragmentArea2D").position = global_position

		powerUp.get_node("FragmentArea2D").connect("area_entered", Callable(get_tree().root.get_node("Prison"), "PowerUp"))
		
		powerUp.name = "powerUp"
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match currentMovement:
		movement.starting:
			pass
		movement.enabled:
			enabled()
		movement.attacking:
			attack(delta)
		movement.charging:
			charging(delta)
		movement.chargeAttacking:
			chargeAttacking()
		movement.chargingSteam:
			chargingSteam(delta)
		movement.steamAttacking:
			steamAttacking(delta)
		movement.stunned:
			stunned(delta)
		#movement.leavingStun: Already in the Animation Script
			#pass
		movement.takingDamage:
			takingDamage(delta)
		movement.dying:
			dying(delta)
	
	move_and_slide()

func _on_damage_body_entered(body : Player):
	var hitbox : HitBoxComponent = body.get_node("HitBoxComponent")		
	var basicAttack = BasicAttack.new()
	basicAttack.damage = 1
	var collision_direction = (body.global_position - global_position).normalized()
	if collision_direction.x < 0:
		basicAttack.direction = -1
	hitbox.damage(basicAttack)


func _on_hit_box_component_area_entered(area):
	if area.name == "Grappling" and canBeDamaged:
		var basicAttack = area.BasicAttack.new()
		$HitBoxComponent.damage(basicAttack)
		if healthStateCounter < 2:
			healthStateCounter += 1
		canBeDamaged = false

func playSound(sound:AudioStream):
	if !playedSound :
		AudioManager.play_sound(sound)
		playedSound = true

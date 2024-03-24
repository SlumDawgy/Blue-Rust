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

var canDoDamage := false

var attackCD := 1.0
var chargeAttackCD := 5.0

var chargeCD := 3.0

var health := 3
var healthState := ["FullHealth", "HalfHealth", "LowHealth"]
var healthStateCounter = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	attackCD -= delta
	chargeAttackCD -= delta
	
	if isTakingDamage:
		damage()
	elif isMoving:
		move()
	elif isAttacking:
		attack()
	elif isCharging:
		charge(delta)
	
	move_and_slide()

	if not is_on_floor():
		velocity.y += gravity * delta
	
	if canDoDamage == true and attackCD <= 0 and isCharging == false:
		isAttacking = true
		isMoving = false
	
	if abs(player.position.x - position.x) > 96 and chargeAttackCD < 0:
		isCharging = true
		isMoving = false
		isAttacking = false
	
	if abs(player.position.x - position.x) < 45 and abs(player.position.y - position.y) < 49:
		player.damage()


func attack():
	velocity.x = 0
	if animation.animation != (healthState[healthStateCounter] + "_Slash"):
		animation.play(healthState[healthStateCounter] + "_Slash")
		
	elif animation.animation == (healthState[healthStateCounter] + "_Slash"):
		if animation.frame == 3:
			isAttacking = false
			isMoving = true
			attackCD = 1
			if canDoDamage == true:
				player.damage()

func move():
	if position.x > player.position.x and player.hangingActive == false:
		velocity.x = -speed
		animation.flip_h = false
		animation.play(healthState[healthStateCounter] + "_Walk")
	elif position.x < player.position.x and player.hangingActive == false:
		velocity.x = speed
		animation.flip_h = true
		animation.play(healthState[healthStateCounter] + "_Walk")
	else:
		velocity.x = 0

func charge(delta):
	if animation.animation != (healthState[healthStateCounter] + "_Charge"):
		animation.play(healthState[healthStateCounter] + "_Charge")
		velocity.x = 0
	
	elif animation.animation == (healthState[healthStateCounter] + "_Charge") && chargeCD > 0:
		chargeCD -= delta
	
	elif animation.animation == (healthState[healthStateCounter] + "_Charge") && chargeCD < 0:
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
			isMoving = true
			chargeAttackCD = 5
			chargeCD = 3
	elif colliderRight != null:
		if  colliderRight.is_in_group("Tile") and velocity.x > 0:
			isCharging = false
			isMoving = true
			chargeAttackCD = 5
			chargeCD = 3
		elif colliderRight.is_in_group("Player") and velocity.x > 0:
			player.damage()
			isCharging = false
			isMoving = true
			chargeAttackCD = 5
			attackCD = 2
			chargeCD = 3
	pass

func stunned():
	pass

func damage():
	if animation.animation != (healthState[healthStateCounter] + "Damage"):
		animation.play(healthState[healthStateCounter] + "Damage")
	
	if animation.frame == 3:
		health -= 1
		healthStateCounter += 1
		isTakingDamage = false
		isMoving = true
	
	pass

func die():
	pass


func _on_area_2d_body_entered(body : CharacterBody2D):
	if body.is_in_group("Player"):
		canDoDamage = true
	pass # Replace with function body.


func _on_area_2d_body_exited(body : CharacterBody2D):
	if body.is_in_group("Player"):
		canDoDamage = false
	pass # Replace with function body.

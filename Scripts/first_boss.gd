extends CharacterBody2D

var player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation := $AnimatedSprite2D


var isAttacking = false
var isMoving := true
var isTakingDamage := false
var isCharging := false
var isShooting := false

var canDoDamage := false

var attackCD := 1.0

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
	
	if isTakingDamage:
		damage()
	elif isMoving:
		move()
	elif isAttacking:
		attack()
	
	move_and_slide()
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if canDoDamage == true and attackCD <= 0:
		isAttacking = true
		isMoving = false


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
		velocity.x = -10
		animation.flip_h = false
		animation.play(healthState[healthStateCounter] + "_Walk")
	elif position.x < player.position.x and player.hangingActive == false:
		velocity.x = 10
		animation.flip_h = true
		animation.play(healthState[healthStateCounter] + "_Walk")
	else:
		velocity.x = 0

func charge():
	pass

func laser():
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

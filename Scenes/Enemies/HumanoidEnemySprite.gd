extends AnimatedSprite2D

var enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy = owner

func chooseAnimations():
	match enemy.currentMovement:
		enemy.movement.enabled:
			play("Idle")
		enemy.movement.moving:
			play("Walking")
		enemy.movement.running:
			play("WalkingAgro")
		enemy.movement.attacking:
			if animation != "Attack":
				play("Attack")
		enemy.movement.takingDamage:
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	chooseAnimations()
	
	if enemy.direction == 1:
		scale.x = -1.2
		%AttackShape.position.x = 23
		enemy.playerDetector.scale.x = -1.2
		position = Vector2(4, -1)
	elif enemy.direction == -1:
		position = Vector2(-2, -1)
		enemy.playerDetector.scale.x = 1.2
		scale.x = 1.2
		%AttackShape.position.x = -21

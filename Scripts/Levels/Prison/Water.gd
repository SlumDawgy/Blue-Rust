extends Area2D

# Player References
var player 
var breathCollider
var healthComponent

# Drowning 


@export var isPolutedWater : bool = false


@export var damage : int = 1
@export var knockback : int = 25
@export var direction : int = 1
@export var knockupwards : int = -300

class WaterDamage:
	var damage
	var knockback
	var direction 
	var knockupwards 

func  _process(delta):
	
	# If player doesn't have item
	if player !=null and isPolutedWater and !player._takingDamage:
		deal_damage()
		
	# If player doesn't have item
	if player != null and player.inWater and player.isInWaterOverHead :
		handle_drown(delta)

func handle_drown(delta) :
	healthComponent.holdBreathTimer -= delta
	if healthComponent.holdBreathTimer <= 0 :
		healthComponent.currentBreath -= 1
		if healthComponent.currentBreath <= 0 :
			deal_damage()
		healthComponent.holdBreathTimer = healthComponent.holdBreathTime

func deal_damage():
	
		var waterDamage = WaterDamage.new()
		waterDamage.damage = damage
		waterDamage.knockback = knockback
		waterDamage.direction = direction
		waterDamage.knockupwards = knockupwards
		player.get_node("HitBoxComponent").damage(waterDamage)

func _on_body_entered(body):
	
	if body.name == "Player":
		player = body
		healthComponent = body.get_node("HitBoxComponent").healthComponentInstance
		body.speed = body.waterSpeed
		body.jumpSpeed = body.waterJumpSpeed
		body.inWater = true

func _on_body_exited(body):
	if body.name == "Player":
		player = null
		body.speed = body.landSpeed
		body.jumpSpeed = body.landJumpSpeed
		body.inWater = false



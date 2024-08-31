extends Area2D

@export var isPolutedWater : bool = false
var player 

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
	if player !=null and isPolutedWater :
		var waterDamage = WaterDamage.new()
		waterDamage.damage = damage
		waterDamage.knockback = knockback
		waterDamage.direction = direction
		waterDamage.knockupwards = knockupwards		
		player.get_node("HitBoxComponent").damage(waterDamage)
		

func _on_body_entered(body):
	
	if body.name == "Player":
		player = body
		body.speed = body.waterSpeed
		body.jumpSpeed = body.waterJumpSpeed
		body.inWater = true
		
		
	

func _on_body_exited(body):
	if body.name == "Player":
		player = null
		body.speed = body.landSpeed
		body.jumpSpeed = body.landJumpSpeed
		body.inWater = false

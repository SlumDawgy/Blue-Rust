extends RigidBody2D

@onready var sprite = $Sprite
@onready var particles = $BeginBreakParticles

var startBreaking : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if sprite.animation == "Broken":
		freeze = false
		if linear_velocity.y == 0:
			await get_tree().create_timer(0.65).timeout
			queue_free()

func _on_start_breaking_body_entered(body : Player):
	if startBreaking == false:
		startBreaking = true
		sprite.play("BeginBreak")
		particles.emitting = true


func _on_broke_body_entered(body : Player):
	if startBreaking == true:
		sprite.play("Broken")
		set_collision_layer_value(4, false)
		set_collision_mask_value(1, false)
		set_collision_mask_value(4, true)

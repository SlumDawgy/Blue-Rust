extends RigidBody2D

@onready var sprite = $Sprite
@onready var particles = $BeginBreakParticles
@onready var brokeParticle = $BrokeParticle

@export var breakingAudio : AudioStream
@export var brokeAudio : AudioStream

var startBreaking : bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if sprite.visible == false:
		await get_tree().create_timer(3.0).timeout
		queue_free()


func _on_start_breaking_body_entered(body : Player):
	if startBreaking == false:
		startBreaking = true
		sprite.play("BeginBreak")
		particles.emitting = true
		AudioManager.play_sound(breakingAudio)


func _on_broke_body_entered(body : Player):
	startBreaking = true
	sprite.visible = false
	brokeParticle.emitting = true
	AudioManager.play_sound(brokeAudio)
	set_collision_layer_value(4, false)
	set_collision_mask_value(1, false)

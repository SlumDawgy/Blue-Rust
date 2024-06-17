extends RigidBody2D

@onready var sprite = $Sprite
@onready var particles = $BeginBreakParticles

@export var breakingAudio : AudioStream
@export var brokeAudio : AudioStream

@export var deleteTimer : float

var startBreaking : bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if sprite.animation == "Broken":
		freeze = false
		await get_tree().create_timer(deleteTimer).timeout
		queue_free()

func _on_start_breaking_body_entered(body : Player):
	if startBreaking == false:
		startBreaking = true
		sprite.play("BeginBreak")
		particles.emitting = true
		AudioManager.play_sound(brokeAudio)


func _on_broke_body_entered(body : Player):
	startBreaking = true
	sprite.play("Broken")
	AudioManager.play_sound(breakingAudio)
	set_collision_layer_value(4, false)
	set_collision_mask_value(1, false)

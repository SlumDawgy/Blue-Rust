extends Node2D

# Player Sprite
@export var playerSprite : Animations

# Footsteps
@export var concreteStepOne : AudioStream
@export var concreteStepTwo : AudioStream
@export var woodStepOne : AudioStream
@export var woodStepTwo : AudioStream

# Other
@export var hurt : AudioStream
@export var grappleRetrieve: AudioStream
@export var grappleShoot : AudioStream
@export var hookAttach : AudioStream
@export var hookHitWall: AudioStream
@export var mantle : AudioStream
@export var mantle_w_Grunt : AudioStream
@export var dash : AudioStream
@export var playerJump : AudioStream
@export var playerJump_w_Grunt : AudioStream
@export var playerLanding : AudioStream
@export var playerLanding_w_Grunt: AudioStream

# Parasol
@export var parasolOpen_A : AudioStream
@export var parasolOpen_B : AudioStream
@export var parasolClose_A : AudioStream
@export var parasolClose_B : AudioStream

#preferabbly this is a list or an array so we can add more than two sounds
func playrandom(r1:AudioStream, r2 :AudioStream):
	var randomRange = RandomNumberGenerator.new()
	var randomNumber = randomRange.randi_range(1,2)
	if randomNumber == 1:
		AudioManager.play_sound(r1)
		
	if randomNumber == 2:
		AudioManager.play_sound(r2)

func _on_player_sprite_frame_changed():
	if "running" in playerSprite.get_animation(): 
		if playerSprite.frame == 0:
			AudioManager.play_sound(concreteStepOne)
		elif playerSprite.frame == 4:
			AudioManager.play_sound(concreteStepTwo)  

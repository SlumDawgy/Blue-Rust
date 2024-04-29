extends Node2D


#footsteps
@export var concreteStepOne : AudioStream
@export var concreteStepTwo : AudioStream
@export var woodStepOne : AudioStream
@export var woodStepTwo : AudioStream

#Other
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

#preferabbly this is a list or an array so we can add more than two sounds
func playrandom(r1:AudioStream, r2 :AudioStream):
	var range = RandomNumberGenerator.new()
	var randomNumber = range.randi_range(1,2)
	if randomNumber == 1:
		AudioManager.play_sound(r1)
		
	if randomNumber == 2:
		AudioManager.play_sound(r2)

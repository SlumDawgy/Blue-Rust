extends Area2D

@export var roomSize : float
@export var damping : float
@export var spread : float
@export var hipass : float
@export var dryLevel : float
@export var wetLevel : float
@export var predelayMsec : float
@export var predelayFeedback : float
@export var reverbOn : bool

func _on_body_entered(body):
	if "Player" in body.name :
		print("Changed Reverb")
		AudioManager.configure_Reverb_Zone(roomSize,damping,spread,hipass,dryLevel,wetLevel,predelayMsec,predelayFeedback,reverbOn)
		

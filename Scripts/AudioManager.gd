extends Node

func play_sound(stream: AudioStream):
	var instance = AudioStreamPlayer.new()
	instance.stream = stream
	instance.bus = GlobalPaths.SFX_BUS
	instance.finished.connect(remove_node.bind(instance))
	add_child(instance)
	instance.pitch_scale = randf_range(0.95,1.05)
	instance.play()
	

func remove_node(instance : AudioStreamPlayer):
	instance.queue_free()

func play_Music(stream: AudioStream):
	var instance = AudioStreamPlayer2D.new()
	instance.stream = stream
	instance.bus = GlobalPaths.BGM_BUS
	add_child(instance)
	instance.play()
	
#Controls the reverb of a level
func configure_Reverb_Zone(RoomSize : float, damping : float, spread : float, highPass : float, dryLevel : float, wetLevel : float, feedbackMsec : float, feedback : float, reverbOn : bool ) :
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("SFX"), 1, reverbOn)
	var reverb = AudioServer.get_bus_effect(AudioServer.get_bus_index("SFX"), 1)
	if reverb.room_size != RoomSize :
		reverb.room_size = RoomSize
	if reverb.damping != damping :
		reverb.damping = damping
	if reverb.spread != spread :
		reverb.spread = spread
	if reverb.hipass != highPass :
		reverb.hipass = highPass
	if reverb.dry != dryLevel :
		reverb.dry = dryLevel
	if reverb.wet != wetLevel :
		reverb.wet = wetLevel
	if reverb.predelay_msec != feedbackMsec :
		reverb.predelay_msec = feedbackMsec
	if reverb.predelay_feedback != feedback :
		reverb.predelay_feedback = feedback

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
	

extends Node

@export var roomSize : HSlider
@export var damping : HSlider
@export var spread : HSlider
@export var hipass : HSlider
@export var dryLevel : HSlider
@export var wetLevel : HSlider
@export var predelayMsec : HSlider
@export var predelayFeedBack : HSlider

func _on_room_size_value_changed(value):
	$CanvasLayer/Node2D/RoomSize/RoomValue.text = str(value* 0.01)
	AudioManager.configure_Reverb_Zone(roomSize.value * 0.01,damping.value * 0.01,spread.value * 0.01,hipass.value * 0.01,dryLevel.value * 0.01,wetLevel.value * 0.01,predelayMsec.value,predelayFeedBack.value * 0.01, true)


func _on_damping_value_changed(value):
	$CanvasLayer/Node2D/Damping/DampingValue.text = str(value* 0.01)
	AudioManager.configure_Reverb_Zone(roomSize.value * 0.01,damping.value * 0.01,spread.value * 0.01,hipass.value * 0.01,dryLevel.value * 0.01,wetLevel.value * 0.01,predelayMsec.value,predelayFeedBack.value * 0.01, true)


func _on_spread_value_changed(value):
	$CanvasLayer/Node2D/Spread/SpreadValue.text = str(value* 0.01)
	AudioManager.configure_Reverb_Zone(roomSize.value * 0.01,damping.value * 0.01,spread.value * 0.01,hipass.value * 0.01,dryLevel.value * 0.01,wetLevel.value * 0.01,predelayMsec.value,predelayFeedBack.value * 0.01, true)


func _on_hi_pass_value_changed(value):
	$CanvasLayer/Node2D/HiPass/hiPassValue.text = str(value* 0.01)
	AudioManager.configure_Reverb_Zone(roomSize.value * 0.01,damping.value * 0.01,spread.value * 0.01,hipass.value * 0.01,dryLevel.value * 0.01,wetLevel.value * 0.01,predelayMsec.value,predelayFeedBack.value * 0.01, true)


func _on_dry_level_value_changed(value):
	$CanvasLayer/Node2D/DryLevel/DryValue.text = str(value* 0.01)
	AudioManager.configure_Reverb_Zone(roomSize.value * 0.01,damping.value * 0.01,spread.value * 0.01,hipass.value * 0.01,dryLevel.value * 0.01,wetLevel.value * 0.01,predelayMsec.value,predelayFeedBack.value * 0.01, true)

func _on_wet_level_value_changed(value):
	$CanvasLayer/Node2D/WetLevel/WetValue.text = str(value* 0.01)
	AudioManager.configure_Reverb_Zone(roomSize.value * 0.01,damping.value * 0.01,spread.value * 0.01,hipass.value * 0.01,dryLevel.value * 0.01,wetLevel.value * 0.01,predelayMsec.value,predelayFeedBack.value * 0.01, true)

func _on_pre_delay_feedback_value_changed(value):
	$CanvasLayer/Node2D/PreDelayFeedback/FeedBackValue.text = str(value* 0.01)
	AudioManager.configure_Reverb_Zone(roomSize.value * 0.01,damping.value * 0.01,spread.value * 0.01,hipass.value * 0.01,dryLevel.value * 0.01,wetLevel.value * 0.01,predelayMsec.value,predelayFeedBack.value * 0.01, true)


func _on_pre_delay_msec_value_changed(value):
	$CanvasLayer/Node2D/PreDelayMsec/MsecValue.text = str(value)
	AudioManager.configure_Reverb_Zone(roomSize.value * 0.01,damping.value * 0.01,spread.value * 0.01,hipass.value * 0.01,dryLevel.value * 0.01,wetLevel.value * 0.01,predelayMsec.value,predelayFeedBack.value * 0.01, true)

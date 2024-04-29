extends HSlider

var busName: String
var busIndex : int
var slider: HSlider


func _ready():
	busName = get_parent().name
	slider = self
	busIndex = AudioServer.get_bus_index(busName)
	slider.value = 100

func _process(delta):
	
	if slider.value_changed:
		AudioServer.set_bus_volume_db(busIndex,linear_to_db(slider.value * 0.01))

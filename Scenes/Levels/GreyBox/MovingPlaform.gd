extends AnimatableBody2D

@export var distance : Vector2
@export_range(1.0,20.0)var speed:float = 6.0
@export_range(0.0,1.0) var offset:float
var pivot : Vector2
var time:float

func _ready():
	pivot = global_position


func get_pos(t: float) ->Vector2:
	var x : float = pivot.x + cos(TAU * (t + offset)) * distance.x
	var y : float = pivot.y + sin(TAU * t) * distance.y
	return Vector2(x,y)

func _physics_process(delta:float) ->void:
		time = fmod(time+delta/speed,1.0)
		global_position = get_pos(time)


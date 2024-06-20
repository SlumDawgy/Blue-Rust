extends Line2D

@export var player : Player
@onready var grappleOrigin : Node2D = owner
@onready var grappleArm : Sprite2D = player.get_node("PlayerSprite/Arm")

func _ready():
	set_point_position(0, Vector2(0,0))

func _physics_process(_delta):
	#if grappleArm.visible:
		#if points.size() == 2:
			#if !player.grapplingHook:
				#if get_point_position(1) != get_local_mouse_position():
					#set_point_position(1, get_local_mouse_position())
		#else:
			#remove_point(1)
	pass

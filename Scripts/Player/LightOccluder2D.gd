extends LightOccluder2D

@onready var player_sprite = $".."
@onready var player = $"../.."


@onready var collision_polygon_2d = $CollisionPolygon2D


var bitmapDict : Dictionary = {}

var initialPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	initialPosition = position
	sprite_to_polygon()
	pass # Replace with function body.

func _physics_process(delta):
	occluder.polygon = bitmapDict[player_sprite.animation][player_sprite.frame].animationPolygons
	position =  bitmapDict[player_sprite.animation][player_sprite.frame].animationPosition
	pass

func sprite_to_polygon() -> void:
	for animationName in player_sprite.sprite_frames.get_animation_names():
		bitmapDict[animationName] = {}
		for animationFrames in player_sprite.sprite_frames.get_frame_count(animationName):
			bitmapDict[animationName][animationFrames] = {}
			var texture = player_sprite.sprite_frames.get_frame_texture(animationName, animationFrames)
			var data = texture.get_image()
			var bitmap = BitMap.new()
			var fullPolygon = OccluderPolygon2D.new()
			bitmap.create_from_image_alpha(data)
			
			var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, texture.get_size()), 0.5)
			for polygon in polys:
				if polys.size() == 1 and fullPolygon != null:
					fullPolygon.polygon.clear()
				
				if polygon == polys[0]:
					fullPolygon.polygon = polys[0]
				if polys.size() > 1:
					fullPolygon.polygon += polygon
			
			bitmapDict[animationName][animationFrames]["animationPolygons"] = fullPolygon.polygon
			bitmapDict[animationName][animationFrames]["animationPosition"] = initialPosition - Vector2(bitmap.get_size()/2)


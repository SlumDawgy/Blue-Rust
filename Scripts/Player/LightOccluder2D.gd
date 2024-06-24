extends LightOccluder2D

@onready var player_sprite = $".."
@onready var player = $"../.."


@onready var collision_polygon_2d = $CollisionPolygon2D


var initialPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	initialPosition = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite_to_polygon()

func sprite_to_polygon() -> void:
	var texture = player_sprite.sprite_frames.get_frame_texture(player_sprite.animation, player_sprite.frame)
	var data = texture.get_image()
	
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(data)
	
	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, texture.get_size()), 0.5)

	for polygon in polys:
		if polys.size() == 1:
			occluder.polygon.clear()
		
		if polygon == polys[0]:
			occluder.polygon = polys[0]
		if polys.size() > 1:
			occluder.polygon += polygon
	position = initialPosition - Vector2(bitmap.get_size()/2)

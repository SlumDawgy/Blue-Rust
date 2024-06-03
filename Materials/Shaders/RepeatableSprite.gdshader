shader_type canvas_item;

uniform float scrollingSpeed = 1.0;

void fragment() {
	vec2 movingUv = vec2(UV.x - (TIME * scrollingSpeed), UV.y);
	vec4 inTex = texture(TEXTURE, movingUv);
	COLOR = inTex;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

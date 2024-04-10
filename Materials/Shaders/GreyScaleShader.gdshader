shader_type canvas_item;

uniform float brightnessModifier = 0.333;
uniform float colorModifier = 1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	vec4 color = texture(TEXTURE, UV);
	float grey = (color.r + color.g + color.b) * brightnessModifier;
	COLOR = vec4(grey* colorModifier,grey * colorModifier,grey *colorModifier, color.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

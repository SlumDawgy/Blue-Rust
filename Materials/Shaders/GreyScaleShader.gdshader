shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	vec4 color = texture(TEXTURE, UV);
	float grey = (color.r + color.g + color.b) * 0.333;
	COLOR = vec4(grey,grey,grey, color.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

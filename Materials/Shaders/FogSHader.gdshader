shader_type canvas_item;

uniform vec4 base_color : source_color;
uniform float location_fade;
uniform float fogSpeed;

void fragment() {
	vec3 fog_color_1 = texture(TEXTURE, vec2(UV.x/2.0 +TIME * fogSpeed, UV.y)).rgb;
	vec3 fog_color_2 = texture(TEXTURE, vec2(UV.x/2.0 +0.5 +TIME * (fogSpeed / 2.0), UV.y /4.0 + 0.5 - TIME * (fogSpeed / 2.0))).rgb;
	vec3 fog_color_3 = texture(TEXTURE, vec2(UV.x/2.0 +0.25 +TIME * (fogSpeed / 3.0), UV.y /4.0 + 0.25 - TIME * (fogSpeed / 2.0))).rgb;

	vec3 fog_color = mix(fog_color_3, mix(fog_color_1, fog_color_2, 0.5),0.7);
	COLOR.a = base_color.a;
	COLOR.rgb = fog_color * base_color.rgb;
	COLOR.rgb += location_fade;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

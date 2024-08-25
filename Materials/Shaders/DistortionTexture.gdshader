shader_type canvas_item;

//Dissolve
uniform float dissolve_percent : hint_range(0.0,1.0) = 0.0;

//Distortion
uniform float distortion_strength: hint_range(-1.0, 1.0) = 0.0;

uniform sampler2D dissolve_noise;
uniform sampler2D dissolve_noise2: repeat_enable;
uniform sampler2D dissolve_noise3: repeat_enable;

uniform vec2 offset1 = vec2(0.1);
uniform vec2 offset2 = vec2(0.2);

uniform float alpha: hint_range(0.0, 1.0) = 1.0;

uniform float floatingSpeedX =1;
uniform float floatingSpeedY =1;

uniform vec4 color: source_color;
void vertex() {
	VERTEX += vec2(0,0);
	VERTEX += vec2(cos(TIME)* floatingSpeedX, sin(TIME)*floatingSpeedY);
}

void fragment() {
	vec4 noise = texture(dissolve_noise,UV);
	vec4 noise_Color1 = texture(dissolve_noise2, UV + offset1 * TIME);
	vec4 noise_Color2 = texture(dissolve_noise3, UV + offset2 * TIME);
	
	float final_noise = noise_Color1.r * noise_Color2.r;
	vec4 final_color = texture(TEXTURE,UV + final_noise * distortion_strength);
	
	if(dissolve_percent >= noise.r)
	{
		final_color.a = 0.0;
		COLOR = vec4(final_color.r + color.r, final_color.g + color.g,final_color.b +color.b, final_color.a);
	}else{
		COLOR = vec4(final_color.r  -color.r, final_color.g  -color.g,final_color.b -color.b, final_color.a * alpha);
	}
}
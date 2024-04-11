shader_type canvas_item;

uniform float refractionMagnitude;
uniform	 sampler2D SCREEN_TEXTURE : hint_screen_texture,filter_linear_mipmap;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 refraction = - texture(TEXTURE,UV).rgb * vec3(1.0,-1.0,1.0);
	
	vec4 textureRead = texture(TEXTURE,UV);
	vec4 offsetScreenRead = textureLod(SCREEN_TEXTURE, SCREEN_UV + refraction.rg / refractionMagnitude,0.5);
	
	if(textureRead.a > 0.04){
		COLOR = offsetScreenRead;
	}
	else {
		
		COLOR = textureRead;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

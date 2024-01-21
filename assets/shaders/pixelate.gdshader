
shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear;
uniform int pixelSize = 8;

void fragment() {
	vec2 new_uv = SCREEN_UV;
	new_uv -= mod(SCREEN_UV, vec2(float(pixelSize)*SCREEN_PIXEL_SIZE.x,float(pixelSize)*SCREEN_PIXEL_SIZE.y));
	vec4 col = texture(SCREEN_TEXTURE, new_uv);
	
	COLOR = vec4(col.r, col.g, col.b, floor(col.a*2.0 - 1.0)) ;
}

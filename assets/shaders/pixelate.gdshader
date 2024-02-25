shader_type canvas_item;

uniform int pixelSize = 8;

void fragment() {
	vec2 new_uv = UV;
	new_uv -= mod(UV, vec2(float(pixelSize)*TEXTURE_PIXEL_SIZE.x,float(pixelSize)*TEXTURE_PIXEL_SIZE.y));
	vec4 col = texture(TEXTURE, new_uv);
	
	COLOR = vec4(col.r, col.g, col.b, floor(col.a*2.0 - 1.0)) ;
}

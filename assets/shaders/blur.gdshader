shader_type canvas_item;

uniform int pixelSize = 1 ;

uniform vec4 line_color : source_color = vec4(1);
uniform float line_thickness : hint_range(0, 10) = 1.0;

vec4 outline(sampler2D tex,vec2 fragCoord, vec2 pixelsize) {
	vec2 size = pixelsize * line_thickness;

	float outline = texture(tex, fragCoord + vec2(-size.x, 0)).a;
	outline += texture(tex, fragCoord + vec2(0, size.y)).a;
	outline += texture(tex, fragCoord + vec2(size.x, 0)).a;
	outline += texture(tex, fragCoord + vec2(0, -size.y)).a;
	outline += texture(tex, fragCoord + vec2(-size.x, size.y)).a;
	outline += texture(tex, fragCoord + vec2(size.x, size.y)).a;
	outline += texture(tex, fragCoord + vec2(-size.x, -size.y)).a;
	outline += texture(tex, fragCoord + vec2(size.x, -size.y)).a;
	outline = min(outline, 1.0);

	vec4 color = texture(tex, fragCoord);
	return mix(color, line_color, outline - color.a);
}

vec4 pixelate(sampler2D sampler, vec2 uv, vec2 pixelsize) {
	vec2 new_uv = uv;
	new_uv -= mod(uv, vec2(float(pixelSize)*pixelsize.x,float(pixelSize)*pixelsize.y));
	return outline(sampler,new_uv,pixelsize);
}

uniform float alpha : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 outline = pixelate(TEXTURE,UV,TEXTURE_PIXEL_SIZE) ;
    COLOR.a = outline.a * alpha;
	COLOR.rgb *= outline.rgb;
}

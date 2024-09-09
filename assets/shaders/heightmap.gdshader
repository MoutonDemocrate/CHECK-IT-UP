shader_type canvas_item;

uniform sampler2D gradient;

void fragment() {
	vec3 col = texture(gradient, vec2(texture(TEXTURE,UV).r)).rgb;
	COLOR.rgb = col * texture(TEXTURE,UV).rgb;
}


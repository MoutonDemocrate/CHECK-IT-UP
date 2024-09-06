shader_type canvas_item;

uniform float ratio : hint_range(0.0, 1.1) = 1.1;

void fragment() {
	float r = 1600.0 / 900.0;
	vec2 uv = vec2((UV.x - 0.5)*r, (UV.y - 0.5));
	if (sqrt(uv.x*uv.x + uv.y*uv.y) < ratio) {
		COLOR *= 0.0;
	}
}

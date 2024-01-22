shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.5 ;
uniform float flip : hint_range(-1.0, 1.0, 2.0) = 1.0 ;
uniform sampler2D image ;

void fragment() {
	vec4 col = textureLod(image, UV, 1.0) ;

	if (UV.x*flip < progress*flip) {
		col.a = 0.0;
	}
	
	COLOR = col ;
	/*COLOR = vec4(col.r, col.g, col.b, floor(col.a*2.0 - 1.0)) ; */
}

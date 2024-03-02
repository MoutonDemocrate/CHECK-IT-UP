shader_type canvas_item;

uniform sampler3D noise ;
uniform sampler2D color_noise ;
uniform float speed : hint_range(0.0, 10.0) = 1.0;
uniform float multi : hint_range(0.0, 5.0) = 2.0;

uniform float movement_speed : hint_range(0.0, 100.0) = 2.0;
uniform float alpha : hint_range(0.0, 1.0) = 1.0;

uniform float edge_strength : hint_range(0.0, 5.0) = 1.0 ;

void fragment() {
	COLOR.a = pow(COLOR.a, edge_strength) ;
	float tr = TIME*0.1 ;
	vec4 sample = texture(noise, vec3(fract(SCREEN_UV.x + tr*movement_speed), SCREEN_UV.y, SCREEN_UV.x));
	COLOR.rgb = texture(color_noise, SCREEN_UV).rgb * vec3(pow(fract(sample.r*multi + speed*tr/(movement_speed*1000.0)),10.0) * alpha);
}

shader_type spatial;

uniform vec3 test_vec ;

vec3 f(vec3 u){
	if (dot(normalize(u), normalize(vec3(1,0,1))) < 0.5) {return vec3(0.0,0.0,1.0);} else {return u;}
}

float test(vec3 normal) {
	return 1.0 - dot(normalize(normal), normalize(test_vec)) ;
}

float fresnel(float amount, vec3 normal, vec3 view) {
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void fragment()
{
	vec3 base_color = vec3(0.0);
	float basic_fresnel = fresnel(2.0, NORMAL, vec3(0,0,1));
	// EMISSION = vec3(basic_fresnel);
	EMISSION = vec3(basic_fresnel) ;
}

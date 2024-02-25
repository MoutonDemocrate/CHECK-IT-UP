shader_type canvas_item;

uniform float intensity = 1.0 ;

uniform vec4 line_color : source_color = vec4(1);
uniform float line_thickness : hint_range(0, 10) = 1.0;

vec4 outline(sampler2D tex,vec2 fragCoord, vec2 pixelSize) {
	vec2 size = pixelSize * line_thickness;
	
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

vec4 blur_size(sampler2D tex,vec2 fragCoord, vec2 pixelSize) {
    
    vec4 color = vec4(0.,0.,0.,0.);

    vec2 pixel = fragCoord/pixelSize;
    int x_min = max(int(pixel.x-intensity), 0);
    int x_max = min(int(pixel.x+intensity), int(1./pixelSize.x));
    int y_min = max(int(pixel.y-intensity), 0);
    int y_max = min(int(pixel.y+intensity), int(1./pixelSize.y));

    int count =0;

    // Sum the pixels colors
    for(int x=x_min; x <= x_max; x++) {
        for(int y = y_min; y <= y_max; y++) {           
            color += outline(tex, vec2(float(x), float(y)) * pixelSize, pixelSize);
            count++;
        }
    }
    
    // Divide the color by the number of colors you summed up
    color /= float(count);
    
    return color;
}

void fragment() {	
    COLOR = blur_size(TEXTURE,UV,TEXTURE_PIXEL_SIZE);
}

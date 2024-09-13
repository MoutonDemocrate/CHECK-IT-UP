shader_type canvas_item;

void fragment() {
	float col = texture(TEXTURE,UV).r;
	col = 1.0 - col;
	COLOR = vec4(col,col,col,col);
}

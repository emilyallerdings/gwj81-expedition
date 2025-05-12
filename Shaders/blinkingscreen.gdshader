shader_type canvas_item;

uniform sampler2D erase_texture_inv;

void fragment() {
    COLOR = texture(erase_texture_inv, UV);
	if(COLOR.rgb != vec3(0,0,0))
	COLOR.a = abs(sin(TIME));
}
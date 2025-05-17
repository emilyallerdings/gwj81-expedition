shader_type canvas_item;

uniform vec4 ending_color : source_color = vec4(1, 0.295, 0.994, 1);
uniform vec4 beginning_color : source_color = vec4(1, 0.681, 0.984, 1);
uniform float pulse_speed = 5.0;

void fragment() {
	 float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;
	 float smooth_pulse = smoothstep(0.0, 1.0, pulse);

	vec4 text_color = mix(beginning_color, ending_color, smooth_pulse);
	COLOR = vec4(text_color.rgb, COLOR.a);

}


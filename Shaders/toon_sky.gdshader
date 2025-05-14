shader_type sky;

uniform sampler2D hdri_background : filter_linear, source_color, hint_default_black;
uniform sampler2D sky_background : filter_linear, source_color, hint_default_black;
uniform sampler2D clouds : filter_linear, source_color, hint_default_black;
uniform sampler2D cloud_color : source_color;
uniform float exposure : hint_range(0, 128) = 1.0;

void sky() {
	if(AT_CUBEMAP_PASS){
		COLOR = texture(hdri_background, SKY_COORDS).rgb * exposure;
	}
	else{
		COLOR = mix(texture(sky_background, SKY_COORDS).rgb, texture(cloud_color, SKY_COORDS).rgb, texture(clouds, SKY_COORDS).r);
	}
}

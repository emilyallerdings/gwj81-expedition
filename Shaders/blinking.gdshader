shader_type spatial;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform float blink_intensity : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    // Use the original PBR material's albedo and metallic properties
    //vec3 base_albedo = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
    //ALBEDO = mix(base_albedo, vec3(1.0), blink_intensity); // Blend with white for a flash
    ALPHA = alpha;
}
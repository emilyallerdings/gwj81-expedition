shader_type canvas_item;

uniform float time;
uniform vec4 color = vec4(0.32, 0.29, 0.51, 1.0); // Loading icon color

void fragment() {
    // Get the UV coordinates and normalize to center
    vec2 uv = UV * 2.0 - 1.0;

    // Calculate the angle and distance from the center
    float angle = atan(uv.y, uv.x);
    float dist = length(uv);

    // Smooth rotation
    float spin = mod(time * 2.0, 6.283); // Rotation speed
    float segment = floor((angle + spin) / (6.283 / 8.0)); // 8 segments

    // Alternate between two states
    float state = mod(floor(time * 2.0), 2.0);

    // Alternate scaling
    float scale = state == 0.0 ? 1.0 : -1.0;

    // Visibility calculation for segment effect
    float visibility = step(0.4, abs(sin(segment * 3.1416 / 4.0 + time * scale * 2.0)));
    vec4 final_color = mix(vec4(0.0), color, visibility);

    // Circular mask to create a ring
    if (dist > 0.5 || dist < 0.3) discard;

    COLOR = final_color;
}
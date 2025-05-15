shader_type canvas_item;

// Ranges from 0 to 1 over the course of the transition.
// We use this to actually animate the shader.
uniform float progress : hint_range(0, 1);



// Size of each diamond, in pixels.
uniform float diamondPixelSize = 10.0f;
uniform bool reverse = false;
uniform sampler2D screen_texture:hint_screen_texture;

void fragment() {
	float xFraction = fract(FRAGCOORD.x / diamondPixelSize);
	float yFraction = fract(FRAGCOORD.y / diamondPixelSize);
	float xDistance = abs(xFraction - 0.5);
	float yDistance = abs(yFraction - 0.5);
	if(!reverse){
		if (xDistance + yDistance + UV.x + UV.y > progress * 4.0f) {
			discard;
		}
	}else{
		if (xDistance + yDistance + UV.x + UV.y < (1.0f - progress) * 4.0f) {
			discard;
		}
	}

}
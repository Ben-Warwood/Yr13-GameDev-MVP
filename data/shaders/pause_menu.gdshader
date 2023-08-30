shader_type canvas_item;
uniform sampler2D distortion_texture;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float brightness: hint_range(0.0, 1.0);
void fragment() {
	// Place fragment code here.
	vec2 distortedUV = SCREEN_UV + texture(distortion_texture, UV).r * 0.05;
	vec4 screenColour = texture(screen_texture, distortedUV);
	COLOR = screenColour;
	COLOR.rgb *= brightness;
}

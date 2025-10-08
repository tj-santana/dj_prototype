shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0);

void vertex() {
}

void fragment() {
	COLOR = vec4(0.0, 0.0, 0.0, progress);
}

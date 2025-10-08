shader_type canvas_item;

// Progress of the swipe (0.0 = start, 1.0 = fully covered)
uniform float progress : hint_range(0.0, 1.0);

// Swipe direction (0 = LEFT, 1 = RIGHT, 2 = UP, 3 = DOWN)
uniform int direction : hint_enum("LEFT", "RIGHT", "UP", "DOWN") = 0;

// Color of the swipe overlay
uniform vec4 color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    vec2 uv = SCREEN_UV;
    float mask = 0.0;

    // LEFT
    if (direction == 0) {
        mask = step(uv.x, progress);
    }
    // RIGHT
    else if (direction == 1) {
        mask = step(1.0 - uv.x, progress);
    }
    // UP
    else if (direction == 2) {
        mask = step(uv.y, progress);
    }
    // DOWN
    else if (direction == 3) {
        mask = step(1.0 - uv.y, progress);
    }

    COLOR = mix(vec4(0.0), color, mask);
}

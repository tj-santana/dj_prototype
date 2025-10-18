shader_type canvas_item;

uniform bool make_white = false;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    if (make_white) {
        // Keep alpha, set RGB to white directly
        COLOR = vec4(1.0, 1.0, 1.0, tex_color.a);
    } else {
        // Normal rendering
        COLOR = tex_color;
    }
}

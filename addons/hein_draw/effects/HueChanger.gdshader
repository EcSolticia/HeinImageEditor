shader_type canvas_item;

uniform float hue_shift : hint_range(0.0, 1.0) = 0.0; // 0.0 to 1.0 = 0° to 360°

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)),
                d / (q.x + e),
                q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec3 rgb = clamp(abs(mod(c.x * 6.0 + vec3(0, 4, 2), 6.0) - 3.0) - 1.0, 0.0, 1.0);
    return c.z * mix(vec3(1.0), rgb, c.y);
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    vec3 hsv = rgb2hsv(tex_color.rgb);
    hsv.x = mod(hsv.x + hue_shift, 1.0); // shift hue
    vec3 rgb = hsv2rgb(hsv);
    COLOR = vec4(rgb, tex_color.a);
}

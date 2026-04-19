shader_type spatial;
render_mode cull_disabled, unshaded;

uniform sampler2D my_texture;
uniform sampler2D noise_texture;
uniform float speed = 0.2;
uniform float noise_intensity = 0.1;

void fragment() {
    vec2 animated_uv = UV + vec2(TIME * speed, TIME * speed * 0.5);
    vec2 noise = texture(noise_texture, UV).rg - vec2(0.5);
    animated_uv += noise * noise_intensity;
    vec4 tex_color = texture(my_texture, animated_uv);
    ALBEDO = tex_color.rgb;
    ALPHA = tex_color.r;
}

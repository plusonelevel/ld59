shader_type sky;

uniform vec3 sky_color : source_color = vec3(0.02, 0.03, 0.06);

uniform float star_density : hint_range(20.0, 400.0) = 180.0;
uniform float star_threshold : hint_range(0.0, 1.0) = 0.98;
uniform float star_size : hint_range(0.001, 0.2) = 0.2;
uniform float star_size_variation : hint_range(0.0, 1.0) = 0.1;
uniform float star_brightness : hint_range(0.0, 10.0) = 2.0;

uniform float cluster_scale : hint_range(1.0, 100.0) = 12.0;
uniform float cluster_strength : hint_range(0.0, 1.0) = 0.5;

float hash1(vec3 p) {
	p = fract(p * 0.1031);
	p += dot(p, p.zyx + 31.32);
	return fract((p.x + p.y) * p.z);
}

vec2 hash2(vec3 p) {
	float n1 = hash1(p);
	float n2 = hash1(p + 17.71);
	return vec2(n1, n2);
}

float value_noise(vec3 p) {
	vec3 i = floor(p);
	vec3 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);

	float n000 = hash1(i + vec3(0.0, 0.0, 0.0));
	float n100 = hash1(i + vec3(1.0, 0.0, 0.0));
	float n010 = hash1(i + vec3(0.0, 1.0, 0.0));
	float n110 = hash1(i + vec3(1.0, 1.0, 0.0));
	float n001 = hash1(i + vec3(0.0, 0.0, 1.0));
	float n101 = hash1(i + vec3(1.0, 0.0, 1.0));
	float n011 = hash1(i + vec3(0.0, 1.0, 1.0));
	float n111 = hash1(i + vec3(1.0, 1.0, 1.0));

	float nx00 = mix(n000, n100, f.x);
	float nx10 = mix(n010, n110, f.x);
	float nx01 = mix(n001, n101, f.x);
	float nx11 = mix(n011, n111, f.x);

	float nxy0 = mix(nx00, nx10, f.y);
	float nxy1 = mix(nx01, nx11, f.y);

	return mix(nxy0, nxy1, f.z);
}

void sky() {
	vec3 dir = normalize(EYEDIR);

	vec3 p = dir * star_density;
	vec3 cell = floor(p);
	vec3 local = fract(p) - 0.5;

	vec3 stars = vec3(0.0);

	float cluster = value_noise(dir * cluster_scale);
	float cluster_bias = mix(1.0, cluster, cluster_strength);

	float star_pick = hash1(cell);

	if (star_pick * cluster_bias > star_threshold) {
		vec2 rnd = hash2(cell) - 0.5;
		vec2 star_pos = rnd * 0.7;

		float size_rand = mix(
			1.0 - star_size_variation,
			1.0,
			hash1(cell + 5.73)
		);
		float final_star_size = star_size * size_rand;

		vec2 d = local.xy - star_pos;
		float circle = 1.0 - smoothstep(final_star_size, final_star_size * 1.35, length(d));
		float intensity = mix(0.4, 1.0, hash1(cell + 3.1)) * star_brightness;

		stars = vec3(circle * intensity);
	}

	COLOR = sky_color + stars;
}
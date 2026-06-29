shader_type canvas_item;

uniform float color_r : hint_range(0.0, 1.0, 0.1);
uniform float color_g : hint_range(0.0, 1.0, 0.1);
uniform float color_b : hint_range(0.0, 1.0, 0.1);
instance uniform float radius = 0.1;

void fragment() {
	vec2 center = vec2(0.5,0.5);
	float dist = sqrt(((center.y - UV.y)*(center.y - UV.y))+((center.x- UV.x)*(center.x- UV.x)));
	float alpha = clamp(dist/radius,0.0,0.975);
		COLOR = vec4(color_r, color_g, color_b,alpha);
}

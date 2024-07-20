shader_type spatial;

render_mode blend_mix, cull_disabled, depth_draw_opaque, diffuse_burley, specular_schlick_ggx, unshaded;

uniform float stability: hint_range(0.0, 2.0) = 0.1;
uniform sampler3D noise;
uniform sampler2D tex;

void vertex(){
	//vec3 displacement = (texture(noise, UV + TIME) * stability);
	vec3 displacement = VERTEX + (NORMAL * (texture(noise, VERTEX + TIME).xyz) * stability);
	//VERTEX = VERTEX + displacement;
	POSITION = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(displacement, 1.0);
}

void fragment(){
	vec3 model_texture = texture(tex, UV).xyz;
	ALBEDO = model_texture.rgb;
	ALPHA = min(0.2 + (1.0 - (NORMAL * VIEW).z * 1.0), 1.0);
}
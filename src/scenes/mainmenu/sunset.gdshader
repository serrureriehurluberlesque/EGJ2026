shader_type canvas_item;

// This uniform lets you drop your color palette texture into the Inspector
uniform sampler2D palette_texture : hint_default_black, filter_nearest;

// This variable will let you animate through different rows of colors
uniform float palette_row_index = 0.0; 
uniform float total_rows = 4.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}



void fragment() {
    // Read the encoded Red and Green values from your character drawing
    vec4 encoded_color = texture(TEXTURE, UV);
	float blend_fraction = fract(palette_row_index);
    float next_row = min(palette_row_index + 1.0, total_rows - 1.0);
	
    // Use the drawn Red channel as X, and our animated uniform row as Y
    // We add a tiny 0.5 offset to read precisely from the center of the palette pixel
    vec2 palette_uv = vec2(encoded_color.r, (palette_row_index + 0.5) / 4.0);
    vec2 palette_uv_next = vec2(encoded_color.r, (next_row) / 4.0);
	
    // Sample the real color from the palette map
    vec4 base_color = texture(palette_texture, palette_uv);
    vec4 next_color = texture(palette_texture, palette_uv_next);
	
	vec4 final_color = mix(base_color, next_color, blend_fraction);
    // Keep the transparency of the original drawing
    final_color.a *= encoded_color.a;
    
    COLOR = final_color;
}
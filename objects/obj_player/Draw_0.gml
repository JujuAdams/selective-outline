//Keep the surfaces alive
if (!surface_exists(surface_1)) surface_1 = surface_create(sprite_width, sprite_height);
if (!surface_exists(surface_2)) surface_2 = surface_create(sprite_width, sprite_height);

draw_sprite_selective_outline(sprite_index, image_index, x, y, image_xscale, image_yscale, image_blend, image_alpha,
                              view_get_camera(0), c_fuchsia, image_alpha, surface_1, surface_2);
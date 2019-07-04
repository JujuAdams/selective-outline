//Keep the surfaces alive
//Doesn't really matter what size the surface is, draw_sprite_selective_outline() resizes the surface if needed
if (!surface_exists(surface_1)) surface_1 = surface_create(1, 1);
if (!surface_exists(surface_2)) surface_2 = surface_create(1, 1);

draw_sprite_selective_outline(sprite_index, image_index, x, y, image_xscale, image_yscale, image_blend, image_alpha,
                              view_get_camera(0), c_fuchsia, image_alpha, surface_1, surface_2);
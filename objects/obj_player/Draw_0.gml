//Keep the surface alive
if (!surface_exists(outline_surface)) outline_surface = surface_create(outline_surface_w, outline_surface_h);
if (!surface_exists(appsurf_outline_surface)) appsurf_outline_surface = surface_create(outline_surface_w, outline_surface_h);


var _sprite = sprite_index;
var _index  = image_index;
var _xscale = image_xscale;
var _yscale = image_yscale;
var _camera = view_get_camera(0);

var _sprite_l = x - 1 - _xscale*sprite_get_xoffset(_sprite);
var _sprite_t = y - 1 - _yscale*sprite_get_yoffset(_sprite);

var _camera_xscale = view_wport[0] / camera_get_view_width( _camera);
var _camera_yscale = view_hport[0] / camera_get_view_height(_camera);
var _surface_l = _camera_xscale*(_sprite_l - camera_get_view_x(_camera));
var _surface_t = _camera_yscale*(_sprite_t - camera_get_view_y(_camera));
var _surface_r = _sprite_l + _camera_xscale*sprite_get_width( _sprite);
var _surface_b = _sprite_t + _camera_yscale*sprite_get_height(_sprite);

surface_set_target(outline_surface);
draw_clear_alpha(c_black, 0.0);
draw_sprite_ext(_sprite, _index,
                _xscale*sprite_get_xoffset(_sprite) + 1, _yscale*sprite_get_yoffset(_sprite) + 1,
                _xscale, _yscale, 0,
                image_blend, image_alpha);
surface_reset_target();

surface_set_target(appsurf_outline_surface);
draw_clear_alpha(c_black, 0.0);

shader_set(shd_selective_outline);
var _texture = surface_get_texture(outline_surface);
texture_set_stage(shader_get_sampler_index(shd_selective_outline, "u_sOutline"), _texture);
shader_set_uniform_f(shader_get_uniform(shd_selective_outline, "u_vTexel"), texture_get_texel_width(_texture), texture_get_texel_height(_texture));
shader_set_uniform_f(shader_get_uniform(shd_selective_outline, "u_vOutlineColour"), c_fuchsia, 1.0); //Colour, Alpha
draw_surface_part_ext(application_surface, _surface_l, _surface_t, _surface_r, _surface_b, 0, 0, 1/_camera_xscale, 1/_camera_yscale, c_white, 1.0);
shader_reset();

surface_reset_target();

draw_surface(appsurf_outline_surface, _sprite_l, _sprite_t);
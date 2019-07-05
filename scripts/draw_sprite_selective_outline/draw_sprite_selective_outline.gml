/// Selective Outline Shader v1.0.0
/// @jujuadams 2019/07/04
///
/// NB. This method is designed to be easy to use rather than super efficient.
///
/// @param sprite
/// @param index
/// @param x
/// @param y
/// @param xscale
/// @param yscale
/// @param colour
/// @param alpha
/// @param camera
/// @param outlineColour
/// @param outlineAlpha
/// @param surface1
/// @param surface2

var _sprite         = argument0;
var _index          = argument1;
var _x              = argument2;
var _y              = argument3;
var _xscale         = argument4;
var _yscale         = argument5;
var _sprite_colour  = argument6;
var _sprite_alpha   = argument7;
var _camera         = argument8;
var _outline_colour = argument9;
var _outline_alpha  = argument10;
var _surface_1      = argument11;
var _surface_2      = argument12;

//Verify the two input surfaces
if (!surface_exists(_surface_1))
{
    show_debug_message("draw_sprite_selective_outline: Surface 1 does not exist!");
    return false;
}

if (!surface_exists(_surface_2))
{
    show_debug_message("draw_sprite_selective_outline: Surface 2 does not exist!");
    return false;
}

var _surface_real_w = 2 + _xscale*sprite_get_width( _sprite);
var _surface_real_h = 2 + _yscale*sprite_get_height(_sprite);

if ((surface_get_width(_surface_1) < _surface_real_w) || (surface_get_height(_surface_1) < _surface_real_h))
{
    show_debug_message("draw_sprite_selective_outline: Surface 1 resized to " + string(_surface_real_w) + "x" + string(_surface_real_h));
    surface_resize(_surface_1, _surface_real_w, _surface_real_h);
}

if ((surface_get_width(_surface_2) < _surface_real_w) || (surface_get_height(_surface_2) < _surface_real_h))
{
    show_debug_message("draw_sprite_selective_outline: Surface 2 resized to " + string(_surface_real_w) + "x" + string(_surface_real_h));
    surface_resize(_surface_2, _surface_real_w, _surface_real_h);
}

//Find the top-left corner of the sprite's quad, correcting for the sprite's origin
var _sprite_l = _x - 1 - _xscale*sprite_get_xoffset(_sprite);
var _sprite_t = _y - 1 - _yscale*sprite_get_yoffset(_sprite);

//Find the portion of the application surface that we want to borrow
var _camera_xscale = 1;
var _camera_yscale = 1;
var _camera_x      = 0;
var _camera_y      = 0;

//Correct for the camera if it's been specified
if (is_real(_camera) && (_camera >= 0))
{
    _camera_xscale = view_wport[0] / camera_get_view_width( _camera);
    _camera_yscale = view_hport[0] / camera_get_view_height(_camera);
    _camera_x      = camera_get_view_x(_camera);
    _camera_y      = camera_get_view_y(_camera);
}

//Figure out what part of the application surface we need to chop out
var _surface_l = max(0, _camera_xscale*(_sprite_l - _camera_x));
var _surface_t = max(0, _camera_yscale*(_sprite_t - _camera_y));
var _surface_r = _surface_l + _camera_xscale*_xscale*(sprite_get_width( _sprite)+2);
var _surface_b = _surface_t + _camera_yscale*_yscale*(sprite_get_height(_sprite)+2);

//Draw the sprite to a temporary surface
//It's possible to avoid using this particular surface if sprites are configured correctly...
//...but using a surface means you don't need to configure sprites at all
surface_set_target(_surface_1);
draw_clear_alpha(c_black, 0.0);

draw_sprite_ext(_sprite, _index,
                _xscale*sprite_get_xoffset(_sprite) + 1, _yscale*sprite_get_yoffset(_sprite) + 1,
                _xscale, _yscale, 0.0,
                _sprite_colour, _sprite_alpha);

surface_reset_target();

//Now we draw to the second surface using our shader
//The shader samples the sprite surface, looking for an edge
//Once it finds an edge, it looks at the application surface
//If the application surface is dark enough, it draws the outline
//If the shader cannot find an edge, it'll draw the sprite as normal
surface_set_target(_surface_2);
draw_clear_alpha(c_black, 0.0);

shader_set(shd_selective_outline);
var _texture = surface_get_texture(_surface_1);
texture_set_stage(shader_get_sampler_index(shd_selective_outline, "u_sSpriteSurface"), _texture);
shader_set_uniform_f(shader_get_uniform(shd_selective_outline, "u_vTexel"), texture_get_texel_width(_texture), texture_get_texel_height(_texture));
shader_set_uniform_f(shader_get_uniform(shd_selective_outline, "u_vOutlineColour"), _outline_colour, _outline_alpha); //colour, alpha

draw_surface_part_ext(application_surface,
                      _surface_l, _surface_t,
                      _surface_r, _surface_b,
                      0, 0,
                      1/_camera_xscale, 1/_camera_yscale,
                      c_white, 1.0);

shader_reset();
surface_reset_target();

//Draw surface 2
draw_surface(_surface_2, _sprite_l, _sprite_t);

return true;
var _string = "Selective Outline Shader v1.0.1\n2019/07/05\n@jujuadams\n\nArrow keys to move";

draw_set_colour(c_black);
draw_text( 9, 10, _string);
draw_text(11, 10, _string);
draw_text(10,  9, _string);
draw_text(10, 11, _string);
draw_set_alpha(0.5);
draw_text(10, 12, _string);
draw_set_colour(c_white);
draw_set_alpha(1.0);
draw_text(10, 10, _string);
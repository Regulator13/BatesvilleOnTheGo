/// @description Draw contol button
draw_sprite(sprite_index, image_index, x, y)

draw_set_halign(fa_center)
draw_set_valign(fa_middle)
draw_text(x, y, controller.get_constant_name(control))

draw_set_halign(fa_right)
draw_text(x-77-48, y, title)
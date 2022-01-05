/// @description Draw order stop circle
draw_set_color(image_blend)
draw_circle(x, y, 16, false)
draw_set_font(fnt_text)
draw_set_halign(fa_middle)
draw_set_valign(fa_middle)
draw_set_color(c_white)
draw_text(x, y, get_order_number(order_id))
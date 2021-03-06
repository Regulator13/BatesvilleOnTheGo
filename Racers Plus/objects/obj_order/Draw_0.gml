/// @description Draw order stop circle
draw_set_color(image_blend)
draw_set_alpha(alarm[0]/expiration)
draw_circle(x, y, 64, false)
draw_set_alpha(1)
draw_circle(x, y, 64, true)
draw_set_font(fnt_text)
draw_set_halign(fa_middle)
draw_set_valign(fa_middle)
draw_set_color(c_white)
draw_text(x, y - 8, get_order_number(order_id))
draw_text(x, y + 8, "$" + string(reward))
/// @description Draw input box

//draw box at top left
draw_set_color(c_black)
draw_rectangle(x - border, y - border, x + box_width + border, y + box_height + border, false)
draw_set_color(c_white)
draw_rectangle(x, y, x + box_width, y + box_height, false)
if field {
	draw_set_color(c_black)
	draw_rectangle(x + edge, y + edge, x + box_width - edge, y + box_height - edge, false)
}

//draw caption
draw_set_halign(fa_right)
draw_set_valign(fa_top)
draw_set_color(c_white)
draw_text(x, y, caption)
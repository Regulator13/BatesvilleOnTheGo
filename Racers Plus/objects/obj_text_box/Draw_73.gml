/// @description  Draw the text box and "caption"

//draw box at top left
draw_set_color(c_black)
draw_rectangle(x - border, y - border, x + max_text_width + border, y + max_text_height + border, false)
draw_set_color(c_white)
draw_rectangle(x, y, x + max_text_width, y + max_text_height, false)

draw_set_font(fnt_basic_small)
draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_set_color(c_black)
if selected and draw_cursor{
	draw_text(x + edge, y + edge, text + "|")
}
else draw_text(x + edge, y + edge, text)

//draw_caption
draw_set_color(c_black)
draw_set_valign(fa_bottom)
draw_text(x - border, y - border - edge, caption)



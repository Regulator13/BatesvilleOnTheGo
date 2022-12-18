/// @description Draw self
if sprite_exists(sprite_index){
	draw_self()
}
else{
	//draw plain button
	draw_set_color(c_black)
	draw_rectangle(x, y, x + box_width, y + box_height, false)
	draw_set_color(c_white)
	draw_rectangle(x, y, x + box_width, y + box_height, true)
	draw_set_halign(fa_middle)
	draw_set_valign(fa_top)
	draw_set_font(fnt_basic_small)
	draw_text(x + box_width/2, y, title)
}
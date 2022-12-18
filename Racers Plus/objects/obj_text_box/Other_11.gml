/// @description Set string
if active{
	if point_in_rectangle(mouse_x, mouse_y, x, y, x + max_text_width + 2*edge, y + max_text_height + 2*edge){
		keyboard_string = text
		//select current box
		selected = true
		draw_cursor = true
		alarm[0] = blink_timer*global.frame_time_multiplier
	}
	else {
		selected = false
	}
}

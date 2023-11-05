/// @description Draw selector
draw_set_font(fnt_menu)
draw_set_color(c_white)
draw_set_valign(fa_middle)

// Draw selector
if ds_list_size(Buttons) > 0{
    var Button = ds_list_find_value(Buttons, selected_button_index)
    if not is_undefined(Button) and instance_exists(Button) and Button.active{
	    var woffset = Button.get_width()
		var hoffset = Button.get_height()/2
	    var dx = Button.x - 32
	    if (dx < 0) {
	        // Draw selector on the other side
	        draw_sprite_ext(spr_selector, -1, Button.x + woffset + 32, Button.y + hoffset, 1, 1, 180, c_white, 1);
	        }
	    else {
	        draw_sprite(spr_selector, -1, Button.x - 32, Button.y + hoffset);
	    }
    }
	else{
		// Attempt to find another button
		var _size = ds_list_size(buttons)
		var tries = _size - 2
		while Buttons[| selected_button_index].active == false and tries > 0{
			selected_button_index = scr_increment_in_bounds(selected_button_index, 1, 0, _size-1, true)
			tries--
		}
	}
}
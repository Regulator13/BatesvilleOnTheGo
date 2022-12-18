/// @description Dropdown
if active{
	var _x = x + box_width + 2*border
	if point_in_rectangle(mouse_x, mouse_y, _x, y, _x + box_height, y + box_height){
		selected = true
	}
	else if selected{
		//check for choosing an option
		var _y = y + box_height + border*2
		var option_amount = array_length(field_options)
		//check options
		for (var i=0; i<option_amount; i++){
			var _oy = _y + box_height*i
			if point_in_rectangle(mouse_x, mouse_y, x + edge, _oy + edge, x + box_width - edge, _oy + box_height - edge){
				selected = false
				field = field_options[i]
				event_user(0)
			}
		}
		selected = false
		obj_menu.continue_input_checking = false
	}
	else selected = false
}

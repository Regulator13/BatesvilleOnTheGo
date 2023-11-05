function menu_create_button(_x, _y, _action, _title, width=154, height=32){
	var Button = instance_create_layer(_x, _y, "lay_networking", obj_button)
	with Button{
		title = _title
		box_width = width
		box_height = height
		
		// Check if common menu action
		switch _action{
			case "back":
				action = function(){
					menu_state_switch(obj_menu.state, ds_stack_top(obj_menu.state_queue))
				}
				break
			case "quit":
				action = function(){
					game_end()
				}
				break
			default:
				action = _action
				break
		}
	}
	return Button
}

function menu_create_slider(_x, _y, action, title, value_amount, values, start_value, value_action) {
	var Button = instance_create_layer(_x, _y, "lay_networking", obj_button)
	Button.action = action
	Button.title = title
	// Add values
	for (var i=0; i<value_amount; i++){
		ds_list_add(Button.values, values[i])
	}
	
	Button.box_width = 154
	Button.box_height = 32
	Button.x -= Button.box_width/2
	Button.y -= Button.box_height/2
	
	if not is_undefined(start_value)
		Button.value = start_value
	
	if not is_undefined(value_action)
		Button.value_action = value_action
	
	return Button
}

/// @param _active | Whether text box can be edited, useful to show remote player text boxes
function menu_create_text_box(_x, _y, _caption, _text, _action="", _active=true, _max_characters=15, _h_align=fa_center, _v_align=fa_middle, _max_box_width=-1, edge=1, border=1){
	var Button = instance_create_layer(_x, _y, "lay_networking", obj_text_box)
	with Button{
		caption = _caption
		text = string(_text)
		action = _action
		active = _active
		max_characters = _max_characters
		max_text_width =_max_box_width
		h_align = _h_align
		v_align = _v_align
		
		// Set font for measuring
		draw_set_font(fnt_menu)
		if max_text_width == -1{
			max_text_width = string_width("A")*_max_characters
		}
		
		// Adjust position to match aligns
		switch h_align{
			case fa_center:
				x -= max_text_width/2
				break	
		}
		var max_text_height = string_height("A")
		switch v_align{
			case fa_middle:
				y -= max_text_height/2
				break
		}
	}
	return Button
}

/// @param type | "color" or "text"
function menu_create_dropdown(_x, _y, type, _field, _field_options, _action, _active, max_width, max_height){
	var Button = instance_create_layer(_x, _y, "lay_networking_above", obj_dropdown)
	with Button{
		box_type = type
		field = _field
		field_options = _field_options
		action = _action
		active = _active
		box_width = max_width
		box_height = max_height
	}
	return Button
}

function menu_create_checkbox(_x, _y, _action, _active, _caption){
	var Button = instance_create_layer(_x, _y, "lay_networking", obj_checkbox)
	with Button{
		action = _action
		active = _active
		caption = _caption
	}
	
	return Button
}
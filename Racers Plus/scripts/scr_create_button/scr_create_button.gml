/// @function scr_create_button(ix, iy, Source, type, action, title, width, height)
/// @description handles the creation of a button
/// @param xx
/// @param yy
/// @param type | button action
function scr_create_button(ix, iy, Source, type, action, title, width, height) {
	// Returns new button ID
	var btn = instance_create_layer(ix, iy, "lay_networking", obj_button)
	btn.Source = Source
	switch type{
		case "host":
			btn.sprite_index = spr_host_btn
			btn.action = "host"
			return btn
		case "direct":
			btn.sprite_index = spr_direct_btn
			btn.action = "direct"
			return btn
		case "quit":
			btn.sprite_index = spr_quit_btn
			btn.action = "quit"
			return btn
		case "back":
			btn.sprite_index = spr_back
			btn.action = "back"
			return btn
		case "restart":
			btn.sprite_index = spr_rest_btn
			btn.action = "restart"
			return btn
		case "ready":
			btn.sprite_index = spr_ready
			btn.action = "ready"
			return btn
		case "plain":
			btn.action = action
			btn.title = title
			btn.box_width = width
			btn.box_height = height
			break
	}
	return btn
}

function scr_create_text_box(ix, iy, Source, caption, text, action, active, max_length, h_align, v_align, max_width, edge, border){
	var button = instance_create_layer(ix, iy, "lay_networking", obj_text_box)
	button.Source = Source
	button.caption = caption
	button.action = action
	button.active = active
	if not is_undefined(max_length) button.max_text_length = max_length
	
	//adjust position in accordance with centering
	draw_set_font(fnt_basic_small)
	if is_undefined(max_width){
		//optional max_width was not set, needed for positioning
		max_width = string_width("A")*max_length
	}
	if not is_undefined(h_align){
		switch h_align{
			case fa_center:
				button.x -= max_width/2
				break
		}
		button.h_align = h_align
	}
	if not is_undefined(v_align){
		//font already set
		var max_height = string_height("A")
		switch v_align{
			case fa_middle:
				button.y -= max_height/2
				break
		}
		button.v_align = v_align
	}
	if not is_undefined(text) button.text = text
	if not is_undefined(max_width) button.max_text_width = max_width
	if not is_undefined(edge) button.edge = edge
	if not is_undefined(border) button.border = border
	return button
}

function scr_create_dropdown(ix, iy, Source, type, field, action, active, max_width, max_height){
	var button = instance_create_layer(ix, iy, "lay_networking_above", obj_dropdown)
	button.Source = Source
	button.box_type = type
	button.field = field
	button.action = action
	button.active = active
	button.box_width = max_width
	button.box_height = max_height
	
	switch type{
		case "color":
			//fill options with colors
			var _length = array_length(obj_menu.color_array)
			for (var i=0; i<_length; i++){
				button.field_options[i] = i
			}
			break
		case "team":
			if instance_exists(obj_lobby.Map){
				for (var i=0; i<obj_lobby.Map.spawn_amount; i++){
					button.field_options[i] = i + 1
				}
			}
			break
		case "text":
			draw_set_font(fnt_basic_small)
			break
		case "spawn":
			draw_set_font(fnt_basic_small)
			break
		case "map":
			//fill options with indexes in map array
			var _length = array_length(obj_lobby.Available_maps)
			for (var i=0; i<_length; i++){
				button.field_options[i] = i
			}
			break
	}
	return button
}

function scr_create_checkbox(ix, iy, Source, action, active, caption){
	var button = instance_create_layer(ix, iy, LAY, obj_checkbox)
	button.Source = Source
	button.action = action
	button.active = active
	button.caption = caption
	
	return button
}
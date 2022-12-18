/// @description Draw score
draw_set_color(c_white)
draw_set_valign(fa_top)
draw_set_halign(fa_left)
draw_text(100*controls, 0, "Tips: " + string(tips))

if inputs[LEFT_KEY] draw_text(100*controls, 48, "Left")
if inputs[RIGHT_KEY] draw_text(100*controls, 16, "Right")
if inputs[UP_KEY] draw_text(100*controls, 32, "Up")
if inputs[DOWN_KEY] draw_text(100*controls, 64, "Down")
draw_text(100*controls, 80, string(direction))

/// @description HTML GUI
if not global.have_server and local and obj_menu.state == STATE_GAME{
	if os_browser != browser_not_a_browser and instance_exists(obj_game_control){
		#region Joystick
		// Joystick base
		var j_x = 128
		var j_y = 128
		var j_b = 64
		var j_r = 64
		draw_set_color(c_white)
		draw_circle(j_x, j_y, j_b, true)
		draw_set_alpha(0.5)
		draw_circle(j_x, j_y, j_b, false)
		draw_set_alpha(1)
		
		//var joystick_button = html_button(undefined, "joystick", "")
		
		//if html_element_interaction(joystick_button){
		inputs[LEFT_KEY] = KEY_ISRELEASED
		inputs[RIGHT_KEY] = KEY_ISRELEASED
		inputs[UP_KEY] = KEY_ISRELEASED
		inputs[DOWN_KEY] = KEY_ISRELEASED
		if mouse_check_button(mb_left){
			var xx = window_mouse_get_x()
			var yy = window_mouse_get_y()
			var dist = point_distance(j_x, j_y, xx, yy)
			var dir = point_direction(j_x, j_y, xx, yy)
			direction = dir
			if dist < 96{
				draw_circle(xx, yy, j_r, true)
				draw_set_alpha(0.5)
				draw_circle(xx, yy, j_r, false)
				draw_set_alpha(1)
				
				// Set inputs
				if dist > 16{
					inputs[LEFT_KEY] = get_joystick_input(dir, LEFT_KEY)
					inputs[RIGHT_KEY] = get_joystick_input(dir, RIGHT_KEY)
					inputs[UP_KEY] = get_joystick_input(dir, UP_KEY)
					inputs[DOWN_KEY] = get_joystick_input(dir, DOWN_KEY)
				}
			}
		}
		#endregion
		/*
		#region HTML
		// See INIT_HTML for all CSS styling based on class
		var grid = html_div(undefined, "grid-container", undefined, "grid-container")
			var display = html_div(grid, "item-display", undefined, "item-display")
			html_div(grid, "item-left", undefined, "item-left")
			html_div(grid, "item-right", undefined, "item-right")
			var manipulate = html_div(grid, "item-manipulate", undefined, "item-manipulate")
				//var flip = html_button(manipulate, "flip", "flip")
				var rotate = html_button(manipulate, "rotate", "rotate")
			var select = html_div(grid, "item-select", undefined, "item-select")
				//type_slider = html_range(select, "type-slider", 0, ds_list_size(blocks)-1, "type-slider", 0)
			var slider = html_div(grid, "item-slider", undefined, "item-slider")
				x_slider = html_range(slider, "x-slider", 0, 100, "type-slider", 0)
			var drop = html_div(grid, "item-drop", undefined, "item-drop")
				var skip_button = html_button(drop, "skip", "skip")
				var drop_button = html_button(drop, "drop", "drop")
				var place_button = html_button(drop, "place", "place")
		#endregion
		
		#region GML
		if not is_undefined(type_slider){
			var type = blocks[| type_slider.value]
		}
		else{
			var type = blocks[| type_index]
		}
		
		if ds_list_size(blocks) > 0{
			draw_sprite_ext(object_get_sprite(obj_game_control.blocks[type]), -1,
					html_element_x(display) + 64, html_element_y(display) + 64, 
					1*image_xscale, 1, image_angle, obj_menu.color_array[player_color], 1)
		}
		
		draw_set_color(c_white)
		draw_set_halign(fa_middle)
		draw_set_valign(fa_top)
		draw_text(490, 8, "Skips: " + string(skips_available))
		draw_text(112, 8, "Blocks Left: " + string(ds_list_size(blocks)))
		#endregion
		
		#region Perform actions
		if ds_list_size(blocks) > 0{
			
			if html_element_interaction(flip){
				image_xscale = -image_xscale
			}
			
			if html_element_interaction(rotate){
				image_angle = scr_increment_in_bounds(image_angle, 90, 0, 359, true)
			}
			if html_element_interaction(skip_button){
				if skips_available > 0{
					type_index = scr_increment_in_bounds(type_index, 1, 0, ds_list_size(blocks)-1, true)
					skips_available--
				}
			}
			if html_element_interaction(drop_button){
				var rotation = image_angle/90
				var _x = x_slider.value
				var drop = true
			
				if not is_undefined(type_slider){
					var type = blocks[| type_slider.value]
					ds_list_delete(blocks, type_slider.value)
					if type_slider.value == ds_list_size(blocks){
						type_slider.value = ds_list_size(blocks) - 1
						html_element_set_property(type_slider, "value", string(ds_list_size(blocks) - 1))
					}
				}
				else{
					var type = blocks[| type_index]
					ds_list_delete(blocks, type_index)
					if type_index == ds_list_size(blocks){
						type_index = ds_list_size(blocks) - 1
					}
				}
			
				scr_client_send_place(obj_client.connect_id, type, rotation, image_xscale, _x, drop)
			}
			if html_element_interaction(place_button){
				var rotation = image_angle/90
				var _x = x_slider.value
				var drop = false
			
				if not is_undefined(type_slider){
					var type = blocks[| type_slider.value]
					ds_list_delete(blocks, type_slider.value)
					if type_slider.value == ds_list_size(blocks){
						type_slider.value = ds_list_size(blocks) - 1
						html_element_set_property(type_slider, "value", string(ds_list_size(blocks) - 1))
					}
				}
				else{
					var type = blocks[| type_index]
					ds_list_delete(blocks, type_index)
					if type_index == ds_list_size(blocks){
						type_index = ds_list_size(blocks) - 1
					}
				}
			
				scr_client_send_place(obj_client.connect_id, type, rotation, image_xscale, _x, drop)
			}
		}
		#endregion
		*/
	}
}
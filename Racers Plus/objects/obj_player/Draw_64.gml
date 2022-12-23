/// @description Draw score
draw_set_color(c_white)
draw_set_valign(fa_top)
draw_set_halign(fa_left)
draw_text(100*controls, 0, "Tips: " + string(tips))

if inputs[LEFT_KEY] draw_text(100*controls, 48, "Left")
if inputs[RIGHT_KEY] draw_text(100*controls, 16, "Right")
if inputs[UP_KEY] draw_text(100*controls, 32, "Up")
if inputs[DOWN_KEY] draw_text(100*controls, 64, "Down")
draw_text(100*controls, 80, string(steer))
draw_text(100*controls, 96, string(throttle))

/// @description HTML GUI
if not global.have_server and local and os_browser != browser_not_a_browser{
	if obj_menu.state == STATE_LOBBY{
		// HTML
		var Grid = html_div(undefined, "grid-container", undefined, "grid-container")
			var Left = html_div(Grid, "action-left", undefined, "action-left", "min-width: 120px")
				var Ready = html_button(Left, "ready", "Ready")
			var Top = html_div(Grid, "hud-top", undefined, "hud-top")
				html_p(Top, "name", player_name)
			var Middle = html_div(Grid, "hud-middle", undefined, "hud-middle")
				html_p(Middle, "team-name", get_team_name(team))
				var Team_slider = html_range(Middle, "team-slider", 1, 2, "type-slider", 1)
			var Bottom = html_div(Grid, "hud-bottom", undefined, "hud-bottom")
				var Color_display = html_div(Bottom, "color", undefined, "color-display",
						"background-color: " + get_html_color(player_color))
				var Color_slider = html_range(Bottom, "color-slider",
						0, array_length(obj_menu.color_array) - 1, "type-slider", 0)
			var Action = html_div(Grid, "action-right", undefined, "action-right")
			var Action_bottom = html_div(Grid, "action-right-bottom", undefined, "action-right-bottom")
				var Model_slider = html_range(Action_bottom, "model-slider",
						0, array_length(obj_menu.model_sprites) - 1, "type-slider", 0)
		
		////DEBUG
		//team = Team_slider.value
		//player_color = Color_slider.value
		//model = Model_slider.value
		
		draw_sprite_ext(obj_menu.model_sprites[model], -1,
					html_element_x(Action) + 100, html_element_y(Action) + 128, 
					2, 2, 1, obj_menu.color_array[player_color], 1)
		
		// Interactions
		if html_element_interaction(Ready){
			scr_client_send_input(obj_client.connect_id, READY_UP, 0, 0)
		}
		
		////TODO Not send every step
		if global.online{
			scr_client_send_lobby_update(obj_client.connect_id, Team_slider.value, Color_slider.value, Model_slider.value)
		}
	}
	if obj_menu.state == STATE_GAME and instance_exists(obj_game_control){
		// This is a phone controller
		throttle = 0
		steer = 0
		
		switch state{
			case STATE_DRIVING:
				#region Driving
				var j_bw = 64
				var j_bh = 16
				var j_r = 48
				draw_set_color(c_white)
				draw_line(0, room_height/2, room_width/2, room_height/2)
				//draw_circle(j_x, j_y, j_b, true)
				draw_roundrect(j_x - j_bw, throttle_y - j_bh, j_x + j_bw, throttle_y + j_bh, true)
				draw_circle(throttle_x, throttle_y, j_r, true)
				draw_set_alpha(0.5)
				//draw_circle(j_x, j_y, j_b, false)
				draw_roundrect(j_x - j_bw, throttle_y - j_bh, j_x + j_bw, throttle_y + j_bh, false)
				draw_circle(throttle_x, throttle_y, j_r, false)
				draw_set_alpha(1)
				
				// Draw picked up deliveries
				draw_set_halign(fa_middle)
				draw_set_valign(fa_center)
				var pizza_radius = 32
				for (var i=0; i<ds_list_size(picked_up_deliveries); i++){
					draw_set_color(c_orange)
					draw_circle(view_wport[0]/2, 2*pizza_radius*(i + 1), pizza_radius, false)
					draw_set_color(c_white)
					draw_text(view_wport[0]/2, 2*pizza_radius*(i + 1), picked_up_deliveries[| i])
				}
				
				throttle_x = j_x
				throttle_y = j_y
				
				// Multi-touch
				for (var i=0; i<2; i++){
					if device_mouse_check_button(i, mb_left){
						var xx = device_mouse_raw_x(i)
						var yy = device_mouse_raw_y(i)
						if xx > room_width/2{
							// Steering joystick
							
							// Joystick base
							if device_mouse_check_button_pressed(i, mb_left){
								j_x = device_mouse_raw_x(i)
								j_y = device_mouse_raw_y(i)
							}
							var dist = point_distance(j_x, j_y, xx, yy)
							
							if dist < 160{
								throttle_x = scr_increment_in_bounds(j_x, xx - j_x, j_x - j_bw, j_x + j_bw, false)
								
								if dist > 8{
									steer = round(((throttle_x - j_x)/j_bw)*10)/10
								}
							}
						}
						else{
							// Throttle
							if yy > room_height/2{
								throttle = 1
							}
							else throttle = -1
						}
				
						draw_circle(xx, yy, j_r, true)
						draw_set_alpha(0.5)
						draw_circle(xx, yy, j_r, false)
						draw_set_alpha(1)
					}
				}
				
				#endregion
				#region Joystick
				/*
				// Joystick base
				if mouse_check_button_pressed(mb_left){
					j_x = window_mouse_get_x()
					j_y = window_mouse_get_y()
				}
				var j_bw = 64
				var j_bh = 16
				var j_r = 48
				draw_set_color(c_white)
				draw_line(j_x - j_bw*2, j_y, j_x + j_bw*2, j_y)
				//draw_circle(j_x, j_y, j_b, true)
				draw_roundrect(j_x - j_bw, throttle_y - j_bh, j_x + j_bw, throttle_y + j_bh, true)
				draw_circle(throttle_x, throttle_y, j_r, true)
				draw_set_alpha(0.5)
				//draw_circle(j_x, j_y, j_b, false)
				draw_roundrect(j_x - j_bw, throttle_y - j_bh, j_x + j_bw, throttle_y + j_bh, false)
				draw_circle(throttle_x, throttle_y, j_r, false)
				draw_set_alpha(1)
				
		
				inputs[LEFT_KEY] = KEY_ISRELEASED
				inputs[RIGHT_KEY] = KEY_ISRELEASED
				inputs[UP_KEY] = KEY_ISRELEASED
				inputs[DOWN_KEY] = KEY_ISRELEASED
				steer = 0
				if mouse_check_button(mb_left){
					var xx = window_mouse_get_x()
					var yy = window_mouse_get_y()
					var dist = point_distance(j_x, j_y, xx, yy)
					var dir = point_direction(j_x, j_y, xx, yy)
					direction = dir
					if dist < 160{
						var d = 24
						if yy > j_y + d{
							throttle = 1
							if yy > j_y + (d + d){
								//j_y = yy - d
							}
						}
						else if yy < j_y - d{
							// Forward
							throttle = -1
							if yy < j_y - (d + d){
								//j_y = yy + d
							}
						}
						else{
							throttle = 0
						}
						throttle_x = scr_increment_in_bounds(j_x, xx - j_x, j_x - j_bw, j_x + j_bw, false)
						throttle_y = j_y + d*throttle
						//draw_circle(xx, yy, j_r, true)
						draw_set_alpha(0.5)
						//draw_circle(xx, yy, j_r, false)
						draw_set_alpha(1)
				
						// Set inputs
						if dist > 8{
							/*
							inputs[LEFT_KEY] = get_joystick_input(dir, LEFT_KEY)
							inputs[RIGHT_KEY] = get_joystick_input(dir, RIGHT_KEY)
							inputs[UP_KEY] = get_joystick_input(dir, UP_KEY)
							inputs[DOWN_KEY] = get_joystick_input(dir, DOWN_KEY)
							
							steer = round(((throttle_x - j_x)/j_bw)*10)/10
						}
					}
				}
				else{
					throttle_x = j_x
					throttle_y = j_y
					throttle = 0
				}
				*/
				#endregion
				break
			case STATE_PICKING_UP:
				#region Pickup GUI
				var Grid = html_div(undefined, "grid-container", undefined, "grid-container")
					html_div(Grid, "action-left", undefined, "action-left",)
					html_div(Grid, "hud-top", undefined, "hud-top")
					html_div(Grid, "hud-middle", undefined, "hud-middle")
					var Bottom = html_div(Grid, "hud-bottom", undefined, "hud-bottom")
					var Action = html_div(Grid, "action-right", undefined, "action-right")
					html_div(Grid, "action-right-bottom", undefined, "action-right-bottom")
					
				var delivery_options = ds_list_size(available_deliveries)
				if delivery_options > 0{
					////DEBUG
					//show_debug_message("obj_player display " + string(delivery_options) + " deliveries")
					
					// List available deliveries to pick up
					var Container = html_div(Action, "delivery-container", undefined, "delivery-container")
					
					for (var i=0; i<delivery_options; i++){
						var order_id = available_deliveries[| i]
						
						////DEBUG
						//show_debug_message("obj_player delivery " + string(i) + " is for " + string(order_id))
						
						// Caution! Each identifier needs to be unique!
						var Available_delivery = html_button(Container, "delivery" + string(i), string(order_id), true, "delivery-button")
						// Select delivery
						if html_element_interaction(Available_delivery){
							scr_client_send_pickup(obj_client.connect_id, order_id)	
						}
					}
				
					// Done button
					var Done = html_button(Bottom, "done", "Done")
					if html_element_interaction(Done){
						////DEBUG
						show_debug_message("obj_player pickup is done")
						
						scr_client_send_pickup(obj_client.connect_id, -1)	
					}
				}
				else{
					// Someone picked up all the deliveries
					
					////DEBUG
					show_debug_message("obj_player all deliveries are picked up")
					
					scr_client_send_pickup(obj_client.connect_id, -1)
					// Keep checking for deliveries continuosly
				}
				
				#endregion
				break
		}
		
		
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
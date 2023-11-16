/// @description HTML GUI

#region Game
// This is a phone controller
throttle = 0
steer = 0

switch state {
	case STATE_INLOBBY:
		#region Lobby
		// HTML
		var Grid = html_div(undefined, "grid-container", undefined, "grid-container")
			var Left = html_div(Grid, "action-left", undefined, "action-left", "min-width: 120px")
				var Ready = html_button(Left, "ready", "Ready")
			var Top = html_div(Grid, "hud-top", undefined, "hud-top")
				html_p(Top, "name", player_name)
			var Middle = html_div(Grid, "hud-middle", undefined, "hud-middle")
				html_p(Middle, "team-name", get_team_name(team))
				var Team_slider = html_range(Middle, "team-slider", 1, 2, "type-slider", 
						string(1))
			var Bottom = html_div(Grid, "hud-bottom", undefined, "hud-bottom")
				var Color_display = html_div(Bottom, "color", undefined, "color-display",
						"background-color: " + get_html_color(player_color))
				var Color_slider = html_range(Bottom, "color-slider",
						0, array_length(color_array) - 1, "type-slider", 0)
			var Action = html_div(Grid, "action-right", undefined, "action-right")
			var Action_bottom = html_div(Grid, "action-right-bottom", undefined, "action-right-bottom")
				var Model_slider = html_range(Action_bottom, "model-slider",
						0, array_length(model_sprites) - 1, "type-slider", model)
		
		////DEBUG
		//team = Team_slider.value
		//player_color = Color_slider.value
		//model = Model_slider.value
		
		draw_sprite_ext(model_sprites[model], -1,
					html_element_x(Action) + 100, html_element_y(Action) + 128, 
					2, 2, 1, color_array[player_color], 1)
		
		// Interactions
		if html_element_interaction(Ready){
			request_action(ACT_LOBBY_UPDATE_PLAYER, 1, obj_hybrid_client.player_name)
		}
		if Team_slider.value != team {
			request_action(ACT_GAME_UPDATE_PLAYER_TEAM, Team_slider.value)
		}
		if Color_slider.value != player_color {
			request_action(ACT_GAME_UPDATE_PLAYER_COLOR, Color_slider.value)
		}
		if Model_slider.value != model {
			request_action(ACT_GAME_UPDATE_PLAYER_MODEL, Model_slider.value)
		}
		#endregion
		break
	case STATE_DRIVING:
		#region Driving
		var w = 128
		var h = 40
		var dx = browser_width/2
		var dy = browser_height - h
		// TODO
		//draw_healthbar(dx - w, 0, dx + w, h, (hp/model_hp_maxes[model])*100, c_white, c_red, c_green, 0, true, true)
		//draw_healthbar(dx - w, dy, dx + w, dy + by + h, (nitrus/model_nitrus_maxes[model])*100, c_white, c_red, c_blue, 0, true, true)

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
			draw_circle(browser_width/2, 2*pizza_radius*(i + 1), pizza_radius, false)
			draw_set_color(c_white)
			draw_text(browser_width/2, 2*pizza_radius*(i + 1), picked_up_deliveries[| i])
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
				var order_number = available_deliveries[| i]
						
				////DEBUG
				//show_debug_message("obj_player delivery " + string(i) + " is for " + string(order_id))
						
				// Caution! Each identifier needs to be unique!
				var Available_delivery = html_button(Container, "delivery" + string(i), string(order_number), true, "delivery-button")
				// Select delivery
				if html_element_interaction(Available_delivery){
					request_action(ACT_GAME_PICKUP, order_number)
				}
			}
				
			// Done button
			var Done = html_button(Bottom, "done", "Done")
			if html_element_interaction(Done){
				////DEBUG
				show_debug_message("obj_player pickup is done")
					
				request_action(ACT_GAME_PICKUP, 255)
			}
		}
		else{
			// Someone picked up all the deliveries
					
			////DEBUG
			show_debug_message("obj_player all deliveries are picked up")
					
			request_action(ACT_GAME_PICKUP, 255)
			// Keep checking for deliveries continuosly
		}
				
		#endregion
		break
}
#endregion
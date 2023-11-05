/// @function scr_server_received_data(Network_player, buff)
/// @description Read client message data - already read GAME_ID and msgID
/// @param Network_player | obj_network_player message is from
/// @returns null
function scr_server_received_data(Network_player, buff) {
	//buffer already in position for reading further
	//read the command, msg_id was already read in obj_server
	var cmd = buffer_read(buff, buffer_u8)

	// handle depending on command
	switch (cmd) {
		case STRING_CMD:
			var input = buffer_read(buff, buffer_u8)
			var input_string = buffer_read(buff, buffer_string)
			//handle input depending on game state
			switch obj_menu.state{
				case STATE_LOBBY:
					switch input{
						case NAME_CHANGE:
							//index in array obj_menu.color_array
							Network_player.player_name = input_string
							break
					}
					break
			}
			break
	    case INPUT_CMD:
			var input = buffer_read(buff, buffer_u8)
			var input_x = buffer_read(buff, buffer_u16)
			var input_y = buffer_read(buff, buffer_u16)
			
			//handle input depending on game state
			switch obj_menu.state{
				case STATE_LOBBY:
					switch input{
						case COLOR_CHANGE:
							//index in array obj_menu.color_array
							obj_lobby.Network_sections[| input_x].spawn_color = input_y
							break
						case PLAYER_COLOR_CHANGE:
							//index in array obj_menu.color_array
							Network_player.player_color = input_x
							break
						case TEAM_CHANGE:
							obj_lobby.Network_sections[| input_x].team = input_y
							break
						case MAP_CHANGE:
							//update the map index for identifying map to clients
							obj_lobby.network_map_index = input_x
							//update lobby map on server right away in order to send out correct messages
							var New_map = obj_lobby.Available_maps[input_x]
							scr_server_update_map(New_map)
							break
						case SECTION_CHANGE:
							var New_section = obj_lobby.Network_sections[| input_x]
							//must check if player is already in section, else code will attempt to keep inserting
							//the player in a different position
							if New_section != Network_player.Section{
								scr_move_sections(Network_player, New_section, ds_list_size(New_section.Players), 0)
							}
							break
					}
					// Break statement intentionally omitted
				case STATE_SCORE:
					if input == READY_UP Network_player.ready_to_start = not Network_player.ready_to_start
					break
				case STATE_GAME:
					with Network_player	scr_perform_input(input, input_x, input_y)
			        break
			}
			break
		case INTERACTION_CMD:
			var interaction = buffer_read(buff, buffer_u8)
			log_message(string("<- TCP INTERACTION_CMD {0}", scr_interaction_to_string(interaction)))
			log_message(string("-> TCP INTERACTION_CMD {0}", scr_interaction_to_string(interaction)))
			
			#region Reflect interaction out to all peers
			// GAME_ID and connect_id are added by scr_server_sent_TCP
	        buffer_seek(buff, buffer_seek_start, 2)
                    
	        //write msg_id
	        buffer_write(buff, buffer_s8, SERVER_PLAY)
			
			// Everything else is the same starting with UNIT_CMD
			buffer_seek(buff, buffer_seek_end, 0)
			
			var message_length = buffer_tell(buff)
			
			var network_player_count = ds_list_size(active_connect_ids)
			for (var i = 0; i < network_player_count; i++){
				// obj_connected_client instances
				var Every_connected_client = ds_map_find_value(Connected_clients, active_connect_ids[| i])
				
				if not server_send_TCP(Every_connected_client, buff, message_length){
					show_debug_message("Warning: TCP interaction message to client failed to send")
				}
			}
			#endregion
			break
		case PICKUP_CMD:
			var Player = Network_player.Player
			var order_number = buffer_read(buff, buffer_s8)
			var order_id = set_order_id(order_number, Player.team)
			var Car = Player.Car
			
			if order_number == -1{
				// Done with pickup
				Player.state = STATE_DRIVING
				// Do not check again to pickup for some time
				Car.alarm[0] = 3*game_get_speed(gamespeed_fps)
			}
			else{
				///TODO Cleanup
				var delivery_options = ds_list_size(Car.available_deliveries)
	
				for (var i=0; i<delivery_options; i++){
					var Delivery = Car.available_deliveries[| i]
					if Delivery.order_id == order_id{
						ds_list_add(Car.picked_up_deliveries, Delivery.order_id)
						instance_destroy(Delivery)
					}
				}
			}
			break
		case UPDATE_CMD:
			var throttle = buffer_read(buff, buffer_s8)
			var steer = buffer_read(buff, buffer_s8)/100
			steer = sign(steer)*power(steer,2)
			
			var Car = Network_player.Player.Car
			if instance_exists(Car){
				//Car.inputs[LEFT_KEY] = left
				//Car.inputs[RIGHT_KEY] = right
				if throttle == -1{
					Car.inputs[UP_KEY] = KEY_ISPRESSED
					Car.inputs[DOWN_KEY] = KEY_ISRELEASED
				}
				else if throttle == 1{
					Car.inputs[UP_KEY] = KEY_ISRELEASED
					Car.inputs[DOWN_KEY] = KEY_ISPRESSED
				}
				else{
					Car.inputs[UP_KEY] = KEY_ISRELEASED
					Car.inputs[DOWN_KEY] = KEY_ISRELEASED
				}
				Car.steer = steer
			}
			break
	}
}

/// @description Client messages
#region Input
input()
#endregion

#region Client messages
//once a frame, we send clients any priority message, if not in game
var network_player_count = ds_list_size(client_connect_ids)  //get the amount of clients connected

//if there is at least one client, continue
if network_player_count > 0{
    //send appropiate game data
    switch obj_menu.state{
        case STATE_LOBBY:
			#region Lobby
            #region Write the regular common TCP state update
			// 3 is the offset for UDP messages, GAME_ID, connect_id
			buffer_seek(game_buffer, buffer_seek_start, 2)
			//write msgId, SERVER_PLAY because client has already logged on
			buffer_write(game_buffer, buffer_s8, SERVER_PLAY)
			//state
			buffer_write(game_buffer, buffer_u8, STATE_LOBBY)
			var message_buffer = scr_write_lobby(game_buffer, 4)
            var message_length = buffer_tell(message_buffer)
			#endregion
            
			// Send a common regular UDP state update to each player unless player
			// has a unique message in their queue
			for (var i=0; i<network_player_count; i++) {
				var Connected_client = ds_map_find_value(Connected_clients, client_connect_ids[| i])

                // Check player's queue
                var message_in_queue = ds_queue_head(Connected_client.messages_out)
				if not is_undefined(message_in_queue) {
	                var buff = confirm_buffer
                        
	                //reset buffer to start - Networking ALWAYS reads from the START of the buffer
	                buffer_seek(buff, buffer_seek_start, 2)
	                //write msg_id
	                buffer_write(buff, buffer_s8, message_in_queue)
					
					write_state_message(message_in_queue, buff, Connected_client)
                    
	                //send confirmation to the client
	                if server_send_TCP(Connected_client, buff, buffer_tell(buff))
						ds_queue_dequeue(Connected_client.messages_out)
					else
						show_debug_message("Warning: TCP server message to client failed to send")
	            }
	            else {
					////TODO
					if Connected_client.connect_id != 0{
						// Write controller lobby
						if instance_exists(Connected_client.Player){
							var message_buffer = controller_write_lobby(game_buffer, 4, Connected_client.Player)
							var message_length = buffer_tell(message_buffer)
							server_send_TCP(Connected_client, message_buffer, message_length)
						}
					}
					else {
		                // Send common regular UDP state update
						log_message("-> TCP SERVER_PLAY")
		                if not server_send_TCP(Connected_client, game_buffer, message_length)
							show_debug_message("Warning: TCP server message to client failed to send")
					}
	            }
            }
			#endregion
            break
		case STATE_GAMECONFIG:
			#region Game unique menu
			#region Write the regular common UDP state update
			// 3 is the offset for UDP messages, GAME_ID, connect_id, udp_sequence_out
			buffer_seek(game_buffer, buffer_seek_start, 3)
			// msg_id = SERVER_PLAY because client has already logged on
			buffer_write(game_buffer, buffer_s8, SERVER_PLAY)
			// state
			buffer_write(game_buffer, buffer_u8, STATE_GAMECONFIG)
			/// Module Integration - Game
			obj_campaign.write_state_update(game_buffer)
            var message_length = buffer_tell(game_buffer)
			#endregion
            
			// Send a common regular UDP state update to each player unless player
			// has a unique message in their queue
			for (var i=0; i<network_player_count; i++) {
				var Connected_client = ds_map_find_value(Connected_clients, client_connect_ids[| i])

                // Check player's queue
                var message_in_queue = ds_queue_head(Connected_client.messages_out)
				if not is_undefined(message_in_queue) {
	                var buff = confirm_buffer
                        
	                //reset buffer to start - Networking ALWAYS reads from the START of the buffer
	                buffer_seek(buff, buffer_seek_start, 2)
	                //write msg_id
	                buffer_write(buff, buffer_s8, message_in_queue)
					
					write_state_message(message_in_queue, buff, Connected_client)
					
					//send confirmation to the client
	                if server_send_TCP(Connected_client, buff, buffer_tell(buff))
						ds_queue_dequeue(Connected_client.messages_out)
					else
						show_debug_message("Warning: TCP server message to client failed to send")
	            }
	            else {
	                //send pre_written lobby data
	                if not server_send_UDP(Connected_client, game_buffer, message_length)
						show_debug_message("Warning: UDP server message to client failed to send")
	            }
            }
			#endregion
            break
        case STATE_GAME:
			#region Game
			// Regular updates are handled by alarm[1]
            
			// Send a common regular UDP state update to each player unless player
			// has a unique message in their queue
			for (var i=0; i<network_player_count; i++) {
				var Connected_client = ds_map_find_value(Connected_clients, client_connect_ids[| i])

                // Check player's queue
                var message_in_queue = ds_queue_head(Connected_client.messages_out)
				if not is_undefined(message_in_queue) {
	                var buff = confirm_buffer
                        
	                //reset buffer to start - Networking ALWAYS reads from the START of the buffer
	                buffer_seek(buff, buffer_seek_start, 2)
	                //write msg_id
	                buffer_write(buff, buffer_s8, message_in_queue)
					
					write_state_message(message_in_queue, buff, Connected_client)
					
					//send confirmation to the client
	                if server_send_reliable_UDP(Connected_client, buff, buffer_tell(buff))
						ds_queue_dequeue(Connected_client.messages_out)
					else
						show_debug_message("Warning: TCP server message to client failed to send")
	            }
            }
			#endregion
            break
		case STATE_SCORE:
			#region Score
            // Game unique menu
			#region Write the regular common UDP state update
			// 3 is the offset for UDP messages, GAME_ID, connect_id, udp_sequence_out
			buffer_seek(game_buffer, buffer_seek_start, 3)
			// msg_id = SERVER_PLAY because client has already logged on
			buffer_write(game_buffer, buffer_s8, SERVER_PLAY)
			// state
			buffer_write(game_buffer, buffer_u8, STATE_SCORE)
			/// Module Integration - Lobby
			obj_campaign.write_state_update(game_buffer)
            var message_length = buffer_tell(game_buffer)
			#endregion
            
			// Send a common regular UDP state update to each player unless player
			// has a unique message in their queue
			for (var i=0; i<network_player_count; i++) {
				var Connected_client = ds_map_find_value(Connected_clients, client_connect_ids[| i])

                // Check player's queue
                var message_in_queue = ds_queue_head(Connected_client.messages_out)
				if not is_undefined(message_in_queue) {
	                var buff = confirm_buffer
                        
	                //reset buffer to start - Networking ALWAYS reads from the START of the buffer
	                buffer_seek(buff, buffer_seek_start, 2)
	                //write msg_id
	                buffer_write(buff, buffer_s8, message_in_queue)
					
					write_state_message(message_in_queue, buff, Connected_client)
					
					//send confirmation to the client
	                if server_send_TCP(Connected_client, buff, buffer_tell(buff))
						ds_queue_dequeue(Connected_client.messages_out)
					else
						show_debug_message("Warning: TCP server message to client failed to send")
	            }
	            else{
	                //send pre_written score data
	                if not server_send_UDP(Connected_client, game_buffer, message_length)
						show_debug_message("Warning: UDP server message to client failed to send")
	            }
            }
			#endregion
            break
    }
}
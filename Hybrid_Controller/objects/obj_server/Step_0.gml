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
					
					log_message(string("-> {0}", message_in_queue))
	            }
            }
			#endregion
            break
		case STATE_GAMECONFIG:
			#region Game unique menu            
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
	                if server_send_TCP(Connected_client, buff, buffer_tell(buff))
						ds_queue_dequeue(Connected_client.messages_out)
					else
						show_debug_message("Warning: TCP server message to client failed to send")
	            }
            }
			#endregion
            break
		case STATE_SCORE:
			#region Score
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
            }
			#endregion
            break
    }
}
/// @description Client messages
//once a frame, we send clients any priority message, if not in game
var network_player_count = ds_list_size(client_connect_ids)  //get the amount of clients connected

//if there is at least one client, continue
if network_player_count > 0{
    //send appropiate game data
    switch global.Menu.state{
        case STATE_LOBBY:
			#region Lobby
            //write the lobby information to the sending buffer
			//write msgId, SERVER_PLAY because client has already logged on
			buffer_write(game_buffer, buffer_s8, SERVER_PLAY)
			//state
			buffer_write(game_buffer, buffer_u8, STATE_LOBBY)
			var message_buffer = scr_write_lobby(game_buffer, 4)
            var message_length = buffer_tell(message_buffer)
            
			for (var i=0; i<network_player_count; i++){
				//get the network player
				var Network_player = ds_map_find_value(Network_players, client_connect_ids[| i])

                //find the type of message to send
                var message = ds_queue_head(Network_player.messages_out)
                
                //check if need to send a confirmation
				if (not is_undefined(message)){
	                //send neccesary confirmation

	                //get the client message buffer
	                var buff = confirmBuffer;
                        
	                //reset buffer to start - Networking ALWAYS reads from the START of the buffer
	                buffer_seek(buff, buffer_seek_start, 2)
                    
	                //write msg_id
	                buffer_write(buff, buffer_s8, message)
					
					switch message{
						case SERVER_STATESWITCH:
							// Reset the ready flag, this will be used throughout each following state
							Network_player.ready_to_start = false
							
							// TODO Block amount
							if Network_player.connect_id != 0{
								var block_amount = TEAM_BLOCK_AMOUNT div ds_list_size(Network_player.Team.Players)
								if block_amount < MIN_BLOCK_AMOUNT
										block_amount = MIN_BLOCK_AMOUNT
							}
							else var block_amount = 0
							buffer_write(buff, buffer_u8, block_amount)
							
							//write authoratitive lobby setting
							buff = scr_write_lobby(buff, buffer_tell(buff))

							break
					}
                        
	                //send confirmation to the client
	                if scr_server_send_TCP(Network_player, buff, buffer_tell(buff))
						ds_queue_dequeue(Network_player.messages_out)
					else
						show_debug_message("Warning: TCP server message to client failed to send")
	            }
	            else {
	                //send pre_written lobby data
	                if not scr_server_send_TCP(Network_player, message_buffer, message_length)
						show_debug_message("Warning: UDP server message to client failed to send")
	            }
            }
			#endregion
            break
        case STATE_GAME:
			#region Game
            //write the lobby information to the sending buffer
			// GAME_ID and connect_id written by scr_send_buffer
			//write msgId, SERVER_PLAY because client has already logged on
			buffer_write(game_buffer, buffer_s8, SERVER_PLAY)
			//state
			buffer_write(game_buffer, buffer_u8, STATE_GAME)
            
			for (var i=0; i<network_player_count; i++){
				//get the network player
				var Network_player = ds_map_find_value(Network_players, client_connect_ids[| i])

                //find the type of message to send
                var message = ds_queue_head(Network_player.messages_out)
                
                //check if need to send a confirmation
				if (not is_undefined(message)){
	                //send neccesary confirmation

	                //get the client message buffer
	                var buff = confirmBuffer;
                        
	                //reset buffer to start - Networking ALWAYS reads from the START of the buffer
	                buffer_seek(buff, buffer_seek_start, 2)
                    
	                //write msg_id
	                buffer_write(buff, buffer_s8, message)
					
					switch message{
						case SERVER_STATESWITCH:
							// Reset the ready flag, this will be used throughout each following state
							Network_player.ready_to_start = false
							
							break
					}
                        
	                //send confirmation to the client
	                if scr_server_send_TCP(Network_player, buff, buffer_tell(buff))
						ds_queue_dequeue(Network_player.messages_out)
					else
						show_debug_message("Warning: TCP server message to client failed to send")
	            }
	            else {
					var message_buffer = scr_write_game(game_buffer, 4, Network_player)
					var message_length = buffer_tell(message_buffer)
					
	                //send pre_written lobby data
	                if not scr_server_send_TCP(Network_player, message_buffer, message_length)
						show_debug_message("Warning: UDP server message to client failed to send")
	            }
            }
			#endregion
            break
		case STATE_SCORE:
			#region Score
            // Write the score information to the sending buffer
			// connect_id
			// Write msgId, SERVER_PLAY because client has already logged on
			buffer_write(game_buffer, buffer_s8, SERVER_PLAY)
			// State
			buffer_write(game_buffer, buffer_u8, STATE_SCORE)
			
			var message_buffer = scr_write_score(game_buffer, 4)
			var message_length = buffer_tell(message_buffer)
            
			for (var i=0; i<network_player_count; i++){
				//get the network player
				var Network_player = ds_map_find_value(Network_players, client_connect_ids[| i])

                //find the type of message to send
                var message = ds_queue_head(Network_player.messages_out)
                
                //check if need to send a confirmation
				if (not is_undefined(message)){
	                //send neccesary confirmation

	                //get the client message buffer
	                var buff = confirmBuffer;
                        
	                //reset buffer to start - Networking ALWAYS reads from the START of the buffer
	                buffer_seek(buff, buffer_seek_start, 2)
                    
	                //write msg_id
	                buffer_write(buff, buffer_s8, message)
					
					switch message{
						case SERVER_STATESWITCH:
							// Reset the ready flag, this will be used throughout each following state
							Network_player.ready_to_start = false
							
							break
					}
                        
	                //send confirmation to the client
	                if scr_server_send_TCP(Network_player, buff, buffer_tell(buff))
						ds_queue_dequeue(Network_player.messages_out)
					else
						show_debug_message("Warning: TCP server message to client failed to send")
	            }
	            else {
	                //send pre_written lobby data
	                if not scr_server_send_TCP(Network_player, message_buffer, message_length)
						show_debug_message("Warning: UDP server message to client failed to send")
	            }
            }
			#endregion
            break
    }
}

//server debug
if (keyboard_check_pressed(vk_f1)) {
    //toggle whether to draw server debug
    serverDebug = not serverDebug
}

function networking_declare_client_interface_functions() {
	// Networking periodic updates
	update_1_wait = -1
	update_2_wait = 1
	
	#region Networking
	/// @description Received a reliable UDP message
	read_reliable_message = function(msg_id, buffer) {
		switch network_state {
			case NETWORK_LOGIN:
				if msg_id == SERVER_LOGIN{
					//recieved confirmation, move to next state
					network_state = NETWORK_LOBBY
					
					// Catch up on the exisiting game
					obj_campaign.read_state(buffer)
					obj_lobby.read_state(buffer)
						
					// If hosting, need to wait till connection is complete,
					// so request is made the first time in obj_client
					if global.have_server{
						var seed = 255
						obj_lobby.request_interaction(LOBBY_INITIALIZE, seed)
					}
						
					// Request to join
					if obj_client.connect_id != 0 {
						obj_campaign.request_interaction(GAME_JOIN, obj_client.connect_id)
						obj_lobby.request_interaction(LOBBY_JOIN)
						obj_lobby.request_interaction(LOBBY_UPDATE_PLAYER, 0, obj_client.player_name)
					}
					
					log_message(scr_network_state_to_string(network_state))
				}
				break
			case NETWORK_LOBBY:
				#region Lobby
				if msg_id == SERVER_PLAY{
					// INTERACTION_CMD from reflecting from server, discard
					buffer_read(buffer, buffer_u8)
					var interaction = buffer_read(buffer, buffer_u8)
					// lobby does not have an interactable id, assume it is obj_lobby
					var interactable_id = buffer_read(buffer, buffer_u16)
						
					with global.Interactables[| interactable_id]{
						read_interaction(interaction, buffer)
					}
					
					log_message(string("<- TCP INTERACTION_CMD {0}", scr_interaction_to_string(interaction)))
				}
				else if msg_id == SERVER_PING{
					// Server is keeping port open
				}
				else if msg_id == SERVER_STATESWITCH{
					//recieved confirmation, move to next state
					/// Module Integration - Networking
					network_state = NETWORK_GAMECONFIG
						
					/// Module Integration - Menu
					menu_state_switch(STATE_LOBBY, STATE_GAMECONFIG)
					
					log_message(scr_network_state_to_string(network_state))
				}
				#endregion
				break
			case NETWORK_GAMECONFIG:
				if msg_id == SERVER_PING{
					// Server is keeping alive
				}
				else if msg_id == SERVER_STATESWITCH{
					//recieved confirmation, move to next state
					network_state = NETWORK_PLAY
						
					#region Update section with authorative info from server
						
					#endregion

					menu_state_switch(STATE_GAMECONFIG, STATE_GAME)
					
					// Continually update server
					if connect_id != 0{
						alarm[2] = update_2_wait
					}
					
					log_message(scr_network_state_to_string(network_state))
				}
				break
			case NETWORK_PLAY:
				if msg_id == SERVER_PLAY{
					var state = buffer_read(buffer, buffer_u8)
					if state == STATE_GAME{
						scr_read_game(buffer)
					}
				}
				else if msg_id == SERVER_PING{
					// Server is keeping alive
				}
				else if msg_id == SERVER_STATESWITCH{
					network_state = NETWORK_SCORE
					
					log_message(scr_network_state_to_string(network_state))
					
					menu_state_switch(STATE_GAME, STATE_SCORE)
					
					if connect_id != 0{
						alarm[2] = -1
					}
					log_message(scr_network_state_to_string(network_state))
				}
				break
			case NETWORK_SCORE:
				if msg_id == SERVER_PLAY{
					var state = buffer_read(buffer, buffer_u8)
					if state == STATE_SCORE{
						scr_read_score(buffer)
					}
				}
				else if msg_id == SERVER_PING{
					// Server is keeping alive
				}
				else if msg_id == SERVER_STATESWITCH{
					network_state = NETWORK_LOBBY
					menu_state_switch(STATE_SCORE, STATE_LOBBY)
					log_message(scr_network_state_to_string(network_state))
				}
				break
		}
	}
	
	/// @description Implementation customizable periodic update #1
	send_update_1 = function() {
		
	}
	/// @description Implementation customizable periodic update #2
	send_update_2 = function() {
		var buff = obj_client.buff
	
		//specific game steps of input will be determined when the server recieves it
		buffer_seek(buff, buffer_seek_start, 0)
	
		//write GAME ID to uniquely define game
		buffer_write(buff, buffer_u8, GAME_ID)
		buffer_write(buff, buffer_u8, connect_id)
		//write msg_id
		buffer_write(buff, buffer_s8, CLIENT_PLAY)
	
		//write command
		buffer_write(buff, buffer_u8,  UPDATE_CMD)
		
		//write input
		buffer_write(buff, buffer_s8, Player.throttle)
		buffer_write(buff, buffer_s8, Player.steer*100)
		
		//send this to the server
		network_send_raw(obj_client.tcp_client, buff, buffer_tell(buff))
		
		log_message("-> TCP CLIENT_PLAY")
	}
	#endregion
}
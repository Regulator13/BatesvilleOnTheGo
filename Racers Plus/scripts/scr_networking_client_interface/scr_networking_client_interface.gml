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
					
					log_message(scr_network_state_to_string(network_state))
				}
				break
			case NETWORK_LOBBY:
				#region Lobby
				if msg_id == SERVER_PLAY{
					var state = buffer_read(buffer, buffer_u8)
					if state == STATE_LOBBY{
						////TODO
						if connect_id == 0{
							scr_read_lobby(buffer)
						}
						else{
							controller_read_lobby(buffer)
						}
					}
				}
				else if msg_id == SERVER_PING{
					// Server is keeping port open
				}
				else if msg_id == SERVER_STATESWITCH{
					//recieved confirmation, move to next state
					network_state = NETWORK_PLAY
					
					log_message(scr_network_state_to_string(network_state))
						
					////TODO
					if global.have_server{
						//Count teams for visibility check
						global.max_teams = obj_lobby.Map.spawn_amount + 1
						
						//set section colors and create keeps
						var count = ds_list_size(obj_lobby.Sections)
						for (var i=0; i<count; i++){
							var Section = obj_lobby.Sections[| i]
							//set an index to reference the section by in the future
							Section.index = i
							if Section.section_type == SPAWN_SECTION{
								//Section.team = Section.Team_box.field
								global.section_color[i] = Section.Color_box.field
							}
						}
						//set player teams and colors
						var count = instance_number(obj_player)
						for (var i=0; i<count; i++){
							var Player = instance_find(obj_player, i)
							// Do not include server host
							if Player.connect_id != 0{
								Player.team = Player.Section.team
								Player.section = Player.Section.index
								Player.player_color = Player.Color_box.field
							}
							
							if Player.connect_id == obj_client.connect_id {
								obj_client.Player = Player
								Player.block_amount = block_amount
							}
						}
					}
					
					menu_state_switch(STATE_LOBBY, STATE_GAME)
				}
				#endregion
				break
			case NETWORK_GAMECONFIG:
				if msg_id == SERVER_STATESWITCH{
					// Continually update server
					if connect_id != 0{
						alarm[2] = update_2_wait
					}
				}
				else if msg_id == SERVER_PING{
					// Server is keeping alive
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
				}
				break
		}
	}
	/// @description Received a reliable UDP message
	read_regular_message = function(msg_id, buffer, state) {
		switch network_state {
			case STATE_LOBBY:
			    #region Lobby updates
				scr_read_lobby(buffer)
								
				#endregion
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
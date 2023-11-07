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
					
					// Request to join
					obj_campaign.request_interaction(GAME_JOIN, obj_client.connect_id)
					obj_lobby.request_interaction(LOBBY_JOIN)
					obj_lobby.request_interaction(LOBBY_UPDATE_PLAYER, 0, obj_client.player_name)
					
					// Manually create client side player tracker
					// since not replicating lobby on clients
					update_player(obj_client.connect_id, "", false)
					
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
					alarm[2] = update_2_wait
					
					log_message(scr_network_state_to_string(network_state))
				}
				break
			case NETWORK_PLAY:
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
					// Server is keeping alive
				}
				else if msg_id == SERVER_STATESWITCH{
					network_state = NETWORK_SCORE
					
					log_message(scr_network_state_to_string(network_state))
					
					menu_state_switch(STATE_GAME, STATE_SCORE)
					
					alarm[2] = -1
					
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
		// obj_player instances
		var Player = obj_client.Network_players[? obj_client.connect_id].Player
		obj_campaign.request_interaction(GAME_DRIVE_UPDATE, connect_id, Player.throttle, Player.steer)
	}
	#endregion
}
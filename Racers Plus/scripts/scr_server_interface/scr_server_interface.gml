function networking_declare_server_interface_functions() {
	// Networking periodic updates
	game_update_wait = 1
	
	// Whether or not game is started
	start = false
	
	input = function() {
		switch obj_menu.state {
			case STATE_LOBBY:
				#region Update readys for network players and start game
				var network_player_count = ds_list_size(active_connect_ids)
				// obj_server.start is reset in menu_state_switch
			    if (not start and network_player_count > 0) {
			        //check for start
			        start = true//set to false if a player is not ready
                
			        //check if any player is not ready
			        for (var i = 0; i < network_player_count; i++){
						// stc_lobby_player
						var player = obj_lobby.players[? obj_server.active_connect_ids[| i]]
						if is_undefined(player) or not player.ready_to_start
							start = false
			        }
                
			        //start if all are ready
			        if (start) {
			            //start game
			            show_debug_message("All ready!")
                    
			            //inform clients game is starting
						for (var i = 0; i < network_player_count; i++){
							// obj_connected_client instances
							var Connected_client = Connected_clients[? active_connect_ids[| i]]
							//actual game start message is handled in obj_server
							ds_queue_enqueue(Connected_client.messages_out, SERVER_STATESWITCH)
						}
						
						// Switch states since no client to do it
						/// Module Integration - Menu
						menu_state_switch(STATE_LOBBY, STATE_GAMECONFIG)
			        }
			    }
				break
			case STATE_GAMECONFIG:
				//start if all are ready
			    if (true) {
			        //start game
			        show_debug_message("All ready!")
                    
			        //inform clients game is starting
					var network_player_count = ds_list_size(active_connect_ids)
					for (var i = 0; i < network_player_count; i++){
						// obj_connected_client instances
						var Connected_client = Connected_clients[? active_connect_ids[| i]]
						//actual game start message is handled in obj_server
						ds_queue_enqueue(Connected_client.messages_out, SERVER_STATESWITCH)
					}
						
					// Switch states since no client to do it
					/// Module Integration - Menu
					menu_state_switch(STATE_GAMECONFIG, STATE_GAME)
			    }
				break
			case STATE_SCORE:
				#region Update readys for network players and start game
				var network_player_count = ds_list_size(active_connect_ids)
				// obj_server.start is reset in menu_state_switch
			    if (not start and network_player_count > 0) {
			        //check for start
			        start = true//set to false if a player is not ready
                
			        //check if any player is not ready
			        for (var i = 0; i < network_player_count; i++){
						// obj_authoritative_player instances
						var Authoritative_player = Connected_clients[? active_connect_ids[| i]].Player
						if not Authoritative_player.ready_to_start
							start = false
			        }
                
			        //start if all are ready
			        if (start) {
			            //start game
			            show_debug_message("All ready!")
                    
			            //inform clients game is starting
						for (var i = 0; i < network_player_count; i++){
							// obj_connected_client instances
							var Connected_client = Connected_clients[? active_connect_ids[| i]]
							//actual game start message is handled in obj_server
							ds_queue_enqueue(Connected_client.messages_out, SERVER_STATESWITCH)
						}
			        }
			    }
				#endregion
		}
	}
	
	#region Networking
	write_state_message = function(message_in_queue, buffer, Connected_client) {
		var Authoritative_player = Connected_client.Player
		switch obj_menu.state {
			case STATE_LOBBY:
				switch message_in_queue {
					case SERVER_LOGIN:
						// SERVER_LOGIN is sent by server_login_client after both connections establish
						break
					case SERVER_STATESWITCH:
						// Game is starting!!
							
						// Reset the ready flag, this will be used throughout each following state
						Authoritative_player.ready_to_start = false
							
						// obj_campaign contains all configurations, so none need to be specifically set here
						break
				}
				break
			case STATE_GAMECONFIG:
				switch message_in_queue {
					case SERVER_STATESWITCH:
						// Reset the ready flag, this will be used throughout each following state
						Authoritative_player.ready_to_start = false
						break
				}
				break
			case STATE_GAME:
				switch message_in_queue {
					case SERVER_STATESWITCH:
						// Reset the ready flag, this will be used throughout each following state
						Authoritative_player.ready_to_start = false
						break
				}
				break
			case STATE_SCORE:
				switch message_in_queue {
					case SERVER_STATESWITCH:
						// Reset the ready flag, this will be used throughout each following state
						Authoritative_player.ready_to_start = false
						break
				}
				break
		}
	}
	
	
	/// @description Received a reliable UDP message
	read_reliable_message = function(msg_id, buffer, Connected_client) {
		// CLIENT_PLAY only msg_ids	
		//all other sockets are connected client sockets, and we have recieved commands from them.
		scr_server_received_data(Connected_client, buffer)
	}
	#endregion
}
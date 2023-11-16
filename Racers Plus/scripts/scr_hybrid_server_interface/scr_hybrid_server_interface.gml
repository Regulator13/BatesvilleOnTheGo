#macro GAME_ID 1

function hybrid_server_declare_interface_functions() {
	// Whether or not game is started
	start = false
	
	input = function() {
		switch obj_menu.state {
			case STATE_LOBBY:
				#region Update readys for network players and start game
				var network_player_count = ds_list_size(active_connect_ids)
				// obj_hybrid_server.start is reset in menu_state_switch
			    if (not start and network_player_count > 0) {
			        //check for start
			        start = true//set to false if a player is not ready
                
			        //check if any player is not ready
			        for (var i = 0; i < network_player_count; i++){
						// stc_lobby_player
						var player = obj_lobby.players[? obj_hybrid_server.active_connect_ids[| i]]
						if is_undefined(player) or not player.ready_to_start
							start = false
			        }
                
			        //start if all are ready
			        if (start) {
			            //start game
			            show_debug_message("All ready!")
						
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
						
					// Switch states since no client to do it
					/// Module Integration - Menu
					menu_state_switch(STATE_GAMECONFIG, STATE_GAME)
			    }
				break
			case STATE_SCORE:
				#region Update readys for network players and start game
				var network_player_count = ds_list_size(active_connect_ids)
				// obj_hybrid_server.start is reset in menu_state_switch
			    if (not start and network_player_count > 0) {
			        //check for start
			        start = true//set to false if a player is not ready
                
			        //check if any player is not ready
			        for (var i = 0; i < network_player_count; i++){
						// obj_player instances
						var Player = Connected_hybrid_clients[? active_connect_ids[| i]].Player
						if not Player.ready_to_start
							start = false
			        }
                
			        //start if all are ready
			        if (start) {
			            //start game
			            show_debug_message("All ready!")
			        }
			    }
				#endregion
		}
	}
}
function networking_declare_server_interface_functions() {
	// Networking periodic updates
	game_update_wait = 1
	
	game_seed = random_get_seed()
	
	// Whether or not game is started
	start = false
	
	input = function() {
		switch obj_menu.state {
			case STATE_LOBBY:
			case STATE_GAMECONFIG:
			case STATE_SCORE:
		}
	}
	
	#region Networking
	write_state_message = function(message_in_queue, buffer, Connected_client) {
		var Authoritative_player = Connected_client.Player
		switch obj_menu.state {
			case STATE_LOBBY:
				switch message_in_queue {
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

	}
	/// @description Received a reliable UDP message
	read_regular_message = function(msg_id, buffer, Connected_client) {
		
	}
	#endregion
}
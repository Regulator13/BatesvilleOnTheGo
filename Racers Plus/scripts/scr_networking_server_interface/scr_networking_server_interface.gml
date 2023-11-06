function networking_declare_server_interface_functions() {
	// Networking periodic updates
	game_update_wait = 1
	
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
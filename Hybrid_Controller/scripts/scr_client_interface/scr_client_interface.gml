function phone_client_declare_interface_functions() {
	#region Networking
	/// @description Received a reliable UDP message
	read_reliable_message = function(msg_id, buffer) {
		switch msg_id {
			case HYBRID_SERVER_CONNECT:
				connect_id = conn_id
				
				//store the socket of the server for sending messages to it
				server_tcp_socket = tcp_client
				
				// Request to join
				obj_player.request_action(ACT_GAME_JOIN, obj_hybrid_client.connect_id)
				obj_player.request_action(ACT_LOBBY_JOIN)
				obj_player.request_action(ACT_LOBBY_UPDATE_PLAYER, 0, obj_hybrid_client.player_name)
					
				log_message(string("<- TCP {0}", scr_hybrid_msg_id_to_string(msg_id)))
				
				break
			case HYBRID_SERVER_PLAY:
				var context = buffer_read(buffer, buffer_u8)
						
				obj_player.read_context(context, buffer)
					
				log_message(string("<- TCP UPDATE_CONTEXT {0}", scr_context_to_string(context)))
				
				break
			case HYBRID_SERVER_PING:
				// Server is keeping alive
				log_message(string("<- TCP {0}", scr_hybrid_msg_id_to_string(msg_id)))
				
				break
		}
	}
	#endregion
}
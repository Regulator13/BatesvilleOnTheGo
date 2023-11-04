/// @function scr_server_send_TCP(Network_player, buffer, length)
/// @description Server function to send a buffer to a client, individualized
/// @param Network_player | player to send to
/// @param buffer | buffer with information to send
/// @param length | length of buffer already
//  Returns Message success
function scr_server_send_TCP(Network_player, buffer, length) {
	//ensure that player is the main one for the client, and not extended
	if not Network_player.extended{
		//write header for specific player
		buffer_seek(buffer, buffer_seek_start, 0)
		//update GAME ID to uniquely define game
		buffer_write(buffer, buffer_u8, GAME_ID)
		//update with specific connect_id
		buffer_write(buffer, buffer_u8, Network_player.connect_id)
	
		//send message
		Network_player.messageSuccess = network_send_raw(Network_player.tcp_socket, buffer, length)
		return (Network_player.messageSuccess >= 0)
	}
	else{
		show_debug_message("Warning! This player extends another client!")
	}
}

/// @function scr_server_send_UDP(ip, index, buffer, length)
/// @description Server function to send a buffer to a client, individualized
/// @param Network_player | player to send to
/// @param buffer | buffer with information to send
/// @param length | length of buffer already
//  Returns Message success
function scr_server_send_UDP(Network_player, buffer, length) {
	//ensure that player is the main one for the client, and not extended
	if not Network_player.extended{
		//update to the clients specific sequence out
		buffer_seek(buffer, buffer_seek_start, 0)
		//update GAME ID to uniquely define game
		buffer_write(buffer, buffer_u8, GAME_ID)
		//update with specific connect_id
		buffer_write(buffer, buffer_u8, Network_player.connect_id)
	
		buffer_write(buffer, buffer_u8, Network_player.udp_sequence_out)
		Network_player.udp_sequence_out = scr_increment_in_bounds(Network_player.udp_sequence_out, 1, 0, SEQUENCE_MAX, true)
	
		//send message
		Network_player.messageSuccess = network_send_udp(udp_server, Network_player.ip, Network_player.udp_port, buffer, length);
		scr_log_send_udp_raw(server_messages_log, Network_player.connect_id, Network_player.udp_sequence_out)
		return (Network_player.messageSuccess >= 0)
	}
	else show_debug_message("Warning! This player extends another client!")
}
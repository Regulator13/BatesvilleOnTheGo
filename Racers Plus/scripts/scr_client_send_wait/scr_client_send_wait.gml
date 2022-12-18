/// @function scr_client_send_wait(current_communication_turn)
/// @description All network input for gameplay, called within obj_player
/// @param current_communication_turn | Communication turn client is processing
//  Returns null
function scr_client_send_wait(current_communication_turn){
	// Move to start of buffer. Networking ALWAYS takes the data from the START of a buffer.
	buffer_seek(buff, buffer_seek_start, 0)

	//write GAME ID to uniquely define game
	buffer_write(buff, buffer_u8, GAME_ID)
	buffer_write(buff, buffer_u8, obj_client.connect_id)
	//write msg_id
	buffer_write(buff, buffer_s8, CLIENT_WAIT)

	//send communication turn that client is on
	buffer_write(buff, buffer_u16, current_communication_turn)

	//send this to the server
	network_send_packet(tcp_client, buff, buffer_tell(buff))
	
	//log this message
	scr_log_send_tcp_raw(client_messages_log, connect_id, CLIENT_WAIT)
	scr_log_send_wait(client_messages_log, current_communication_turn)
}

/// @function scr_client_send_performance(actual_microseconds)
/// @description Inform the client of how long a turn actually took so it can adjust
/// @param actual fps | the actual fps of the previous turn using get_timer()
//  Returns null
function scr_client_send_performance(actual_microseconds){
	var buff = obj_client.buff
	// Move to start of buffer. Networking ALWAYS takes the data from the START of a buffer.
	buffer_seek(buff, buffer_seek_start, 0)

	//write GAME ID to uniquely define game
	buffer_write(buff, buffer_u8, GAME_ID)
	buffer_write(buff, buffer_u8, obj_client.connect_id)
	//write msg_id
	buffer_write(buff, buffer_s8, CLIENT_PERFORMANCE)

	//send communication turn that client is on
	buffer_write(buff, buffer_u8, round(actual_microseconds/1000))

	//send this to the server
	network_send_packet(obj_client.tcp_client, buff, buffer_tell(buff))
	
	//log this message
	scr_log_send_tcp_raw(obj_client.client_messages_log, obj_client.connect_id, CLIENT_PERFORMANCE)
}

/// @function hybrid_client_send_ping(connect_id)
/// @description Send input to server
/// @param input | input key to send
//  Returns null
function hybrid_client_send_ping(connect_id) {
	var buff = obj_hybrid_client.message_buffer
	
	//specific game steps of input will be determined when the server recieves it
	buffer_seek(buff, buffer_seek_start, 0)
	
	//write GAME ID to uniquely define game
	buffer_write(buff, buffer_u8, GAME_ID)
	buffer_write(buff, buffer_u8, connect_id)
	//write msg_id
	buffer_write(buff, buffer_s8, HYBRID_CLIENT_PING)
		
	//send this to the server
	//network_send_packet(obj_client.tcp_client, buff, buffer_tell(buff))
	var message_success = network_send_raw(obj_hybrid_client.tcp_client, buff, buffer_tell(buff))
	
	log_message("-> TCP HYBRID_CLIENT_PING")
	return message_success
}
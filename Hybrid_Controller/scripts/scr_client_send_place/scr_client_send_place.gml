/// @function scr_client_send_input(connect_id, input, x, y)
/// @description Send input to server
/// @param input | input key to send
//  Returns null
function scr_client_send_pickup(connect_id, pickup){
	var buff = obj_client.buff
	
	//specific game steps of input will be determined when the server recieves it
	buffer_seek(buff, buffer_seek_start, 0)
	
	//write GAME ID to uniquely define game
	buffer_write(buff, buffer_u8, GAME_ID)
	buffer_write(buff, buffer_u8, connect_id)
	//write msg_id
	buffer_write(buff, buffer_s8, CLIENT_PLAY)
	
	//write command
	buffer_write(buff, buffer_s8, PICKUP_CMD)
		
	//write input
	buffer_write(buff, buffer_u8, pickup)
		
	//send this to the server
	network_send_raw(obj_client.tcp_client, buff, buffer_tell(buff))
}

/// @function client_send_update(connect_id, update_id, _1, _2, _3, _4)
/// @description Send input to server
//  Returns null
function client_send_update(connect_id, update_id, _1, _2, _3, _4) {
	var buff = obj_client.message_buffer
	
	//move to start of buffer. Networking ALWAYS takes the data from the START of a buffer.
    buffer_seek(buff, buffer_seek_start, 0);
    
	//write GAME ID to uniquely define game
	buffer_write(buff, buffer_u8, GAME_ID)
	
	//write identifing connect_id
	buffer_write(buff, buffer_u8, connect_id)
    //write msg_id
    buffer_write(buff, buffer_s8, CLIENT_PLAY)
	
	// Write update identifier
    buffer_write(buff, buffer_u8, update_id)
	buffer_write(buff, buffer_u16, _1)
	buffer_write(buff, buffer_u16, _2)
	buffer_write(buff, buffer_s8, _3)
	buffer_write(buff, buffer_s8, _4)
	
	obj_client.udp_sequence_out = scr_increment_in_bounds(obj_client.udp_sequence_out, 1, 0, SEQUENCE_MAX, true)
	
    //send this to the server
    var message_success = network_send_udp(obj_client.udp_client, obj_client.server_ip, obj_client.server_udp_port, buff, buffer_tell(buff))
	if (message_success < 0){ //network_send_udp returns number less than zero if message fails
		show_debug_message("obj_client client_send_update UDP message failed")
	}
	return message_success
}

////TODO Put in better place
function scr_client_send_lobby_update(connect_id, team, color, model){
	var buff = obj_client.buff
	
	//specific game steps of input will be determined when the server recieves it
	buffer_seek(buff, buffer_seek_start, 0)
	
	//write GAME ID to uniquely define game
	buffer_write(buff, buffer_u8, GAME_ID)
	buffer_write(buff, buffer_u8, connect_id)
	//write msg_id
	buffer_write(buff, buffer_s8, CLIENT_PLAY)
	
	//write command
	buffer_write(buff, buffer_u8,  UPDATE_LOBBY_CMD)
		
	//write input
	buffer_write(buff, buffer_u8, team)
	buffer_write(buff, buffer_u8, color)
	buffer_write(buff, buffer_u8, model)
		
	//send this to the server
	network_send_raw(obj_client.tcp_client, buff, buffer_tell(buff))
}
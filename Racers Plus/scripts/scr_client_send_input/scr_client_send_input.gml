/// @function scr_client_send_input(connect_id, input, x, y)
/// @description Send input to server
/// @param input | input key to send
//  Returns null
function scr_client_send_input(connect_id, input, _x	, _y){
	var buff = obj_client.buff
	
	//specific game steps of input will be determined when the server recieves it
	buffer_seek(buff, buffer_seek_start, 0)
	
	//write GAME ID to uniquely define game
	buffer_write(buff, buffer_u8, GAME_ID)
	buffer_write(buff, buffer_u8, connect_id)
	//write msg_id
	buffer_write(buff, buffer_s8, CLIENT_PLAY)
	
	//write command
	buffer_write(buff, buffer_u8, INPUT_CMD)
		
	//write input
	buffer_write(buff, buffer_u8, input)
	buffer_write(buff, buffer_u16, _x)
	buffer_write(buff, buffer_u16, _y)
		
	//send this to the server
	network_send_raw(obj_client.tcp_client, buff, buffer_tell(buff))
}

/// @function scr_client_send_name(connect_id, name)
/// @description Send input to server
/// @param input | input key to send
//  Returns null
function scr_client_send_name(connect_id, name){
	var buff = obj_client.buff
	
	//specific game steps of input will be determined when the server recieves it
	buffer_seek(buff, buffer_seek_start, 0)
	
	//write GAME ID to uniquely define game
	buffer_write(buff, buffer_u8, GAME_ID)
	buffer_write(buff, buffer_u8, connect_id)
	//write msg_id
	buffer_write(buff, buffer_s8, CLIENT_PLAY)
	
	//write command
	buffer_write(buff, buffer_u8, STRING_CMD)
		
	//write input
	buffer_write(buff, buffer_u8, NAME_CHANGE)
	buffer_write(buff, buffer_string, name)
		
	//send this to the server
	network_send_raw(obj_client.tcp_client, buff, buffer_tell(buff))
}

/// @function scr_client_send_input(connect_id, input, x, y)
/// @description Send input to server
/// @param input | input key to send
//  Returns null
function scr_client_send_place(connect_id, type, rotation, xscale, x_slider, drop){
	var buff = obj_client.buff
	
	//specific game steps of input will be determined when the server recieves it
	buffer_seek(buff, buffer_seek_start, 0)
	
	//write GAME ID to uniquely define game
	buffer_write(buff, buffer_u8, GAME_ID)
	buffer_write(buff, buffer_u8, connect_id)
	//write msg_id
	buffer_write(buff, buffer_s8, CLIENT_PLAY)
	
	//write command
	buffer_write(buff, buffer_u8, PLACE_CMD)
		
	//write input
	buffer_write(buff, buffer_u8, type)
	buffer_write(buff, buffer_u8, rotation)
	buffer_write(buff, buffer_s8, xscale)
	buffer_write(buff, buffer_u8, x_slider)
	buffer_write(buff, buffer_u8, drop)
		
	//send this to the server
	network_send_packet(obj_client.tcp_client, buff, buffer_tell(buff))
}

function scr_client_send_update(connect_id, Player){
	var buff = obj_client.buff
	
	//specific game steps of input will be determined when the server recieves it
	buffer_seek(buff, buffer_seek_start, 0)
	
	//write GAME ID to uniquely define game
	buffer_write(buff, buffer_u8, GAME_ID)
	buffer_write(buff, buffer_u8, connect_id)
	//write msg_id
	buffer_write(buff, buffer_s8, CLIENT_PLAY)
	
	//write command
	buffer_write(buff, buffer_u8,  UPDATE_CMD)
		
	//write input
	buffer_write(buff, buffer_s8, Player.inputs[LEFT_KEY])
	buffer_write(buff, buffer_s8, Player.inputs[RIGHT_KEY])
	buffer_write(buff, buffer_s8, Player.inputs[UP_KEY])
	buffer_write(buff, buffer_s8, Player.inputs[DOWN_KEY])
		
	//send this to the server
	network_send_packet(obj_client.tcp_client, buff, buffer_tell(buff))
}
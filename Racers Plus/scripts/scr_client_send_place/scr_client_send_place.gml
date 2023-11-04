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
	buffer_write(buff, buffer_s8, Player.throttle)
	buffer_write(buff, buffer_s8, Player.steer*100)
		
	//send this to the server
	network_send_raw(obj_client.tcp_client, buff, buffer_tell(buff))
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
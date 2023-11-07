/// @function client_request_action(action, buff, length)
/// @description Send input to server
/// @param  action | The type of action
/// @param  buff | The message buffer
/// @param length | The length of the message buffer
//  Returns null
function client_request_action(action, buff, length) {
	//specific game steps of input will be determined when the server recieves it
	buffer_seek(buff, buffer_seek_start, 0)
	
	//write GAME ID to uniquely define game
	buffer_write(buff, buffer_u8, GAME_ID)
	buffer_write(buff, buffer_u8, obj_client.connect_id)
	//write msg_id
	buffer_write(buff, buffer_s8, CLIENT_PLAY)
	
	//write command
	buffer_write(buff, buffer_u8, ACTION_CMD)
		
	//write input
	buffer_write(buff, buffer_u8, action)
	
	// Preserve contents
	buffer_seek(buff, buffer_seek_start, length)
		
	//send this to the server
	var message_success = network_send_raw(obj_client.tcp_client, buff, buffer_tell(buff))
	
	obj_client.log_message(string("-> TCP ACTION_CMD {0}", scr_action_to_string(action)))
	
	return message_success
}

function request_action_u8(action, input_1){
	var buff = obj_client.message_buffer
	// GAME_ID, CLIENT_PLAY, action_CMD, 
	buffer_seek(buff, buffer_seek_start, 5)
	
	// Contents of the action
	buffer_write(buff, buffer_u8, input_1)
	
	client_request_action(action, buff, buffer_tell(buff))
}

function request_action_u8_u8(action, input_1, input_2){
	var buff = obj_client.message_buffer
	// GAME_ID, CLIENT_PLAY, action_CMD, 
	buffer_seek(buff, buffer_seek_start, 5)
	
	// Contents of the action
	buffer_write(buff, buffer_u8, input_1)
	buffer_write(buff, buffer_u8, input_2)
	
	client_request_action(action, buff, buffer_tell(buff))
}

function request_action_u8_u8_string(action, input_1, input_2, input_3){
	var buff = obj_client.message_buffer
	// GAME_ID, CLIENT_PLAY, action_CMD, 
	buffer_seek(buff, buffer_seek_start, 5)
	
	// Contents of the action
	buffer_write(buff, buffer_u8, input_1)
	buffer_write(buff, buffer_u8, input_2)
	buffer_write(buff, buffer_string, input_3)
	
	client_request_action(action, buff, buffer_tell(buff))
}

function request_action_u8_s16_s16(action, input_1, input_2, input_3){
	var buff = obj_client.message_buffer
	// GAME_ID, CLIENT_PLAY, action_CMD, 
	buffer_seek(buff, buffer_seek_start, 5)
	
	// Contents of the action
	buffer_write(buff, buffer_u8, input_1)
	buffer_write(buff, buffer_s16, input_2)
	buffer_write(buff, buffer_s16, input_3)
	
	client_request_action(action, buff, buffer_tell(buff))
}

function request_action_s16_s16(action, input_1, input_2){
	var buff = obj_client.message_buffer
	// GAME_ID, CLIENT_PLAY, action_CMD, 
	buffer_seek(buff, buffer_seek_start, 5)
	
	// Contents of the action
	buffer_write(buff, buffer_s16, input_1)
	buffer_write(buff, buffer_s16, input_2)
	
	client_request_action(action, buff, buffer_tell(buff))
}
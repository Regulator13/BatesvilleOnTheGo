/// @function server_update_context(connect_id, context, buff, length)
/// @description Send input to server
/// @param  Connected_client
/// @param  context | The type of context
/// @param  buff | The message buffer
/// @param length | The length of the message buffer
//  Returns null
function server_update_context(Connected_client, context, buff, length) {
	// GAME_ID and connect_id are added by scr_server_sent_TCP
	buffer_seek(buff, buffer_seek_start, 2)
	
	//write msg_id
	buffer_write(buff, buffer_s8, SERVER_PLAY)
		
	//write input
	buffer_write(buff, buffer_u8, context)
	
	//send this to the server
	var message_success = server_send_TCP(Connected_client, buff, length)
	
	obj_server.log_message(string("-> TCP ACTION_CMD {0}", scr_context_to_string(context)))
	
	return message_success
}

function update_context_u8(Connected_client, context, input_1){
	var buff = obj_server.action_buffer
	// GAME_ID, connect_id, CLIENT_PLAY, ACTION_CMD, 
	buffer_seek(buff, buffer_seek_start, 4)
	
	// Contents of the context
	buffer_write(buff, buffer_u8, input_1)
	
	server_update_context(Connected_client, context, buff, buffer_tell(buff))
}

function update_context_u8_u8(Connected_client, context, input_1, input_2){
	var buff = obj_server.action_buffer
	// GAME_ID, connect_id, CLIENT_PLAY, ACTION_CMD, 
	buffer_seek(buff, buffer_seek_start, 4)
	
	// Contents of the context
	buffer_write(buff, buffer_u8, input_1)
	buffer_write(buff, buffer_u8, input_2)
	
	server_update_context(Connected_client, context, buff, buffer_tell(buff))
}

function update_context_u8_u8_string(Connected_client, context, input_1, input_2, input_3){
	var buff = obj_server.action_buffer
	// GAME_ID, connect_id, CLIENT_PLAY, ACTION_CMD, 
	buffer_seek(buff, buffer_seek_start, 4)
	
	// Contents of the context
	buffer_write(buff, buffer_u8, input_1)
	buffer_write(buff, buffer_u8, input_2)
	buffer_write(buff, buffer_string, input_3)
	
	server_update_context(Connected_client, context, buff, buffer_tell(buff))
}

function update_context_u8_s16_s16(Connected_client, context, input_1, input_2, input_3){
	var buff = obj_server.action_buffer
	// GAME_ID, connect_id, CLIENT_PLAY, ACTION_CMD, 
	buffer_seek(buff, buffer_seek_start, 4)
	
	// Contents of the context
	buffer_write(buff, buffer_u8, input_1)
	buffer_write(buff, buffer_s16, input_2)
	buffer_write(buff, buffer_s16, input_3)
	
	server_update_context(Connected_client, context, buff, buffer_tell(buff))
}

function update_context_s16_s16(Connected_client, context, input_1, input_2){
	var buff = obj_server.action_buffer
	// GAME_ID, connect_id, CLIENT_PLAY, ACTION_CMD, 
	buffer_seek(buff, buffer_seek_start, 4)
	
	// Contents of the context
	buffer_write(buff, buffer_s16, input_1)
	buffer_write(buff, buffer_s16, input_2)
	
	server_update_context(Connected_client, context, buff, buffer_tell(buff))
}
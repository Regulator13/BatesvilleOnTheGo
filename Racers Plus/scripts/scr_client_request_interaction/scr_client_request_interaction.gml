/// @function client_request_interaction(connect_id, interactable_id, interaction, buff, length)
/// @description Send input to server
/// @param  connect_id | Identifier for character requesting the interaction
/// @param  interactable_id | Identifier of the instance being interacted with
/// @param  interaction | The type of interaction
/// @param  buff | The message buffer
/// @param length | The length of the message buffer
//  Returns null
function client_request_interaction(connect_id, interactable_id, interaction, buff, length) {
	//specific game steps of input will be determined when the server recieves it
	buffer_seek(buff, buffer_seek_start, 0)
	
	//write GAME ID to uniquely define game
	buffer_write(buff, buffer_u8, GAME_ID)
	buffer_write(buff, buffer_u8, connect_id)
	//write msg_id
	buffer_write(buff, buffer_s8, CLIENT_PLAY)
	
	//write command
	buffer_write(buff, buffer_u8, INTERACTION_CMD)
		
	//write input
	buffer_write(buff, buffer_u8, interaction)
	buffer_write(buff, buffer_u16, interactable_id)
	
	// Preserve contents
	buffer_seek(buff, buffer_seek_start, length)
		
	//send this to the server
	var message_success = network_send_raw(obj_client.tcp_client, buff, buffer_tell(buff))
	
	obj_client.log_message(string("-> TCP INTERACTION_CMD {0}", scr_interaction_to_string(interaction)))
	
	return message_success
}

function request_interaction_u8(connect_id, interactable_id, interaction, input_1){
	var buff = obj_client.message_buffer
	// GAME_ID, connect_id, CLIENT_PLAY, INTERACTION_CMD, 
	buffer_seek(buff, buffer_seek_start, 7)
	
	// Contents of the interaction
	buffer_write(buff, buffer_u8, input_1)
	
	client_request_interaction(connect_id, interactable_id, interaction, buff, buffer_tell(buff))
}

function request_interaction_u8_u8(connect_id, interactable_id, interaction, input_1, input_2){
	var buff = obj_client.message_buffer
	// GAME_ID, connect_id, CLIENT_PLAY, INTERACTION_CMD, 
	buffer_seek(buff, buffer_seek_start, 7)
	
	// Contents of the interaction
	buffer_write(buff, buffer_u8, input_1)
	buffer_write(buff, buffer_u8, input_2)
	
	client_request_interaction(connect_id, interactable_id, interaction, buff, buffer_tell(buff))
}

function request_interaction_u8_u8_string(connect_id, interactable_id, interaction, input_1, input_2, input_3){
	var buff = obj_client.message_buffer
	// GAME_ID, connect_id, CLIENT_PLAY, INTERACTION_CMD, 
	buffer_seek(buff, buffer_seek_start, 7)
	
	// Contents of the interaction
	buffer_write(buff, buffer_u8, input_1)
	buffer_write(buff, buffer_u8, input_2)
	buffer_write(buff, buffer_string, input_3)
	
	client_request_interaction(connect_id, interactable_id, interaction, buff, buffer_tell(buff))
}

function request_interaction_u8_s16_s16(connect_id, interactable_id, interaction, input_1, input_2, input_3){
	var buff = obj_client.message_buffer
	// GAME_ID, connect_id, CLIENT_PLAY, INTERACTION_CMD, 
	buffer_seek(buff, buffer_seek_start, 7)
	
	// Contents of the interaction
	buffer_write(buff, buffer_u8, input_1)
	buffer_write(buff, buffer_s16, input_2)
	buffer_write(buff, buffer_s16, input_3)
	
	client_request_interaction(connect_id, interactable_id, interaction, buff, buffer_tell(buff))
}

function request_interaction_s16_s16(connect_id, interactable_id, interaction, input_1, input_2){
	var buff = obj_client.message_buffer
	// GAME_ID, connect_id, CLIENT_PLAY, INTERACTION_CMD, 
	buffer_seek(buff, buffer_seek_start, 7)
	
	// Contents of the interaction
	buffer_write(buff, buffer_s16, input_1)
	buffer_write(buff, buffer_s16, input_2)
	
	client_request_interaction(connect_id, interactable_id, interaction, buff, buffer_tell(buff))
}

function request_interaction_u8_u8_u16_u16_s16_s16(){
	var buff = obj_client.message_buffer
	// GAME_ID, connect_id, CLIENT_PLAY, INTERACTION_CMD, 
	buffer_seek(buff, buffer_seek_start, 7)
	
	// Contents of the interaction
	buffer_write(buff, buffer_u8, argument3)
	buffer_write(buff, buffer_u8, argument4)
	buffer_write(buff, buffer_u16, argument5)
	buffer_write(buff, buffer_u16, argument6)
	buffer_write(buff, buffer_s16, argument7)
	buffer_write(buff, buffer_s16, argument8)
	
	client_request_interaction(argument0, argument1, argument2, buff, buffer_tell(buff))
}
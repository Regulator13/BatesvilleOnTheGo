/// @function server_push_interaction(connect_id, interactable_id, interaction, buff, length)
/// @description Send input to server
/// @param  Connected_client
/// @param  interactable_id | Identifier of the instance being interacted with
/// @param  interaction | The type of interaction
/// @param  buff | The message buffer
/// @param length | The length of the message buffer
//  Returns null
function server_push_interaction(Connected_client, interactable_id, interaction, buff, length) {
	// GAME_ID and connect_id are added by scr_server_sent_TCP
	buffer_seek(buff, buffer_seek_start, 2)
	
	//write msg_id
	buffer_write(buff, buffer_s8, SERVER_PLAY)
	
	//write command
	buffer_write(buff, buffer_u8, INTERACTION_CMD)
		
	//write input
	buffer_write(buff, buffer_u8, interaction)
	buffer_write(buff, buffer_u16, interactable_id)
	
	//send this to the server
	var message_success = server_send_TCP(Connected_client, buff, length)
	
	obj_server.log_message(string("-> TCP INTERACTION_CMD {0}", scr_interaction_to_string(interaction)))
	
	return message_success
}

function push_interaction_u8(Connected_client, interactable_id, interaction, input_1){
	var buff = obj_server.interaction_buffer
	// GAME_ID, connect_id, CLIENT_PLAY, INTERACTION_CMD, 
	buffer_seek(buff, buffer_seek_start, 7)
	
	// Contents of the interaction
	buffer_write(buff, buffer_u8, input_1)
	
	server_push_interaction(Connected_client, interactable_id, interaction, buff, buffer_tell(buff))
}

function push_interaction_u8_u8(Connected_client, interactable_id, interaction, input_1, input_2){
	var buff = obj_server.interaction_buffer
	// GAME_ID, connect_id, CLIENT_PLAY, INTERACTION_CMD, 
	buffer_seek(buff, buffer_seek_start, 7)
	
	// Contents of the interaction
	buffer_write(buff, buffer_u8, input_1)
	buffer_write(buff, buffer_u8, input_2)
	
	server_push_interaction(Connected_client, interactable_id, interaction, buff, buffer_tell(buff))
}

function push_interaction_u8_u8_string(Connected_client, interactable_id, interaction, input_1, input_2, input_3){
	var buff = obj_server.interaction_buffer
	// GAME_ID, connect_id, CLIENT_PLAY, INTERACTION_CMD, 
	buffer_seek(buff, buffer_seek_start, 7)
	
	// Contents of the interaction
	buffer_write(buff, buffer_u8, input_1)
	buffer_write(buff, buffer_u8, input_2)
	buffer_write(buff, buffer_string, input_3)
	
	server_push_interaction(Connected_client, interactable_id, interaction, buff, buffer_tell(buff))
}

function push_interaction_u8_s16_s16(Connected_client, interactable_id, interaction, input_1, input_2, input_3){
	var buff = obj_server.interaction_buffer
	// GAME_ID, connect_id, CLIENT_PLAY, INTERACTION_CMD, 
	buffer_seek(buff, buffer_seek_start, 7)
	
	// Contents of the interaction
	buffer_write(buff, buffer_u8, input_1)
	buffer_write(buff, buffer_s16, input_2)
	buffer_write(buff, buffer_s16, input_3)
	
	server_push_interaction(Connected_client, interactable_id, interaction, buff, buffer_tell(buff))
}

function push_interaction_s16_s16(Connected_client, interactable_id, interaction, input_1, input_2){
	var buff = obj_server.interaction_buffer
	// GAME_ID, connect_id, CLIENT_PLAY, INTERACTION_CMD, 
	buffer_seek(buff, buffer_seek_start, 7)
	
	// Contents of the interaction
	buffer_write(buff, buffer_s16, input_1)
	buffer_write(buff, buffer_s16, input_2)
	
	server_push_interaction(Connected_client, interactable_id, interaction, buff, buffer_tell(buff))
}

function push_interaction_u8_u8_u16_u16_s16_s16(){
	var buff = obj_server.interaction_buffer
	// GAME_ID, connect_id, CLIENT_PLAY, INTERACTION_CMD, 
	buffer_seek(buff, buffer_seek_start, 7)
	
	// Contents of the interaction
	buffer_write(buff, buffer_u8, argument3)
	buffer_write(buff, buffer_u8, argument4)
	buffer_write(buff, buffer_u16, argument5)
	buffer_write(buff, buffer_u16, argument6)
	buffer_write(buff, buffer_s16, argument7)
	buffer_write(buff, buffer_s16, argument8)
	
	server_push_interaction(argument0, argument1, argument2, buff, buffer_tell(buff))
}
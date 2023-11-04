/// @function scr_client_reply_ping()
/// @description Reply to servers ping with timing information
//  Returns null
function scr_client_reply_ping(){
	// Move to start of buffer. Networking ALWAYS takes the data from the START of a buffer.
	buffer_seek(buff, buffer_seek_start, 0)

	//write GAME ID to uniquely define game
	buffer_write(buff, buffer_u8, GAME_ID)
	buffer_write(buff, buffer_u8, obj_client.connect_id)
	//write msg_id
	buffer_write(buff, buffer_s8, CLIENT_PING)

	//send real fps info so server knows performance
	//var avg_fps = round(total_real_fps/count_real_fps)
	//set variables for debug
	average_actual_fps = floor(scr_ds_list_average(previous_actual_fps))
	maximum_actual_fps =floor(scr_ds_list_maximum(previous_actual_fps))
	buffer_write(buff, buffer_u8, average_actual_fps)
	buffer_write(buff, buffer_u8, maximum_actual_fps)
	total_real_fps = 0
	count_real_fps = 0

	//send this to the server
	network_send_raw(tcp_client, buff, buffer_tell(buff))
	scr_log_send_tcp_raw(client_messages_log, connect_id, CLIENT_PING)
}

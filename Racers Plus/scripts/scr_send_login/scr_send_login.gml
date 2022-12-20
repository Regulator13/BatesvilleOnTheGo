/// @function scr_send_login(name)
/// @description Sends the name of the client to the server
/// @param name | name to send
/// @returns null
function scr_send_login(name){
	//Move to start of buffer. Networking ALWAYS takes the data from the START of a buffer.
	buffer_seek(buff, buffer_seek_start, 0);

	//write GAME ID to uniquely define game
	buffer_write(buff, buffer_u8, GAME_ID)
	
	buffer_write(buff, buffer_u8, connect_id)
	//write msgId
	buffer_write(buff, buffer_s8, CLIENT_LOGIN)
	//write the name into the buffer.
	buffer_write(buff, buffer_string, name);

	//send this to the server
	//buffer_tell automatically accounts for what was written, and therefore sends the smallest possible size
	network_send_packet(server_tcp_socket, buff, buffer_tell(buff))
	scr_log_send_tcp_raw(client_messages_log, connect_id, CLIENT_LOGIN)
}

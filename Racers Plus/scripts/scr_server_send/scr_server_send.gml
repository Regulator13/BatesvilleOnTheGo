/// @function server_send_TCP(Connected_client, buffer, length)
/// @description Server function to send a buffer to a client, individualized
/// @param Connected_client | player to send to
/// @param buffer | buffer with information to send
/// @param length | length of buffer already
//  Returns Message success
function server_send_TCP(Connected_client, buffer, length) {
	//ensure that player is the main one for the client, and not extended
	if not Connected_client.extended{
		//write header for specific player
		buffer_seek(buffer, buffer_seek_start, 0)
		//update GAME ID to uniquely define game
		buffer_write(buffer, buffer_u8, GAME_ID)
		//update with specific connect_id
		buffer_write(buffer, buffer_u8, Connected_client.connect_id)
	
		//send message
		Connected_client.message_success = network_send_raw(Connected_client.tcp_socket, buffer, length)
		return (Connected_client.message_success >= 0)
	}
	else{
		show_debug_message("Warning! This player extends another client!")
	}
}
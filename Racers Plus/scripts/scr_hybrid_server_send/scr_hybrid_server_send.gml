/// @function hybrid_server_send_TCP(Connected_hybrid_client, buffer, length)
/// @description Server function to send a buffer to a client, individualized
/// @param Connected_hybrid_client | player to send to
/// @param buffer | buffer with information to send
/// @param length | length of buffer already
//  Returns Message success
function hybrid_server_send_TCP(Connected_hybrid_client, buffer, length) {
	//write header for specific player
	buffer_seek(buffer, buffer_seek_start, 0)
	//update GAME ID to uniquely define game
	buffer_write(buffer, buffer_u8, GAME_ID)
	//update with specific connect_id
	buffer_write(buffer, buffer_u8, Connected_hybrid_client.connect_id)
	
	//send message
	Connected_hybrid_client.message_success = network_send_raw(Connected_hybrid_client.tcp_socket, buffer, length)
	return (Connected_hybrid_client.message_success >= 0)
}
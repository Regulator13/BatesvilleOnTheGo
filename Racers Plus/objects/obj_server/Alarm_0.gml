/// @description  Broadcast our location occasionally. Clients pick this up and can then display servers to the user. 
if obj_menu.state == STATE_LOBBY{
	buffer_seek(broadcast_buffer, buffer_seek_start, 0);
	buffer_write(broadcast_buffer, buffer_u8, GAME_ID)
	buffer_write(broadcast_buffer, buffer_string, server_name);
	network_send_broadcast(udp_server, BROADCAST_PORT, broadcast_buffer, buffer_tell(broadcast_buffer));

	//broadcast once a second...
	alarm[0] = BROADCAST_RATE

	show_debug_message("broadcast")
}
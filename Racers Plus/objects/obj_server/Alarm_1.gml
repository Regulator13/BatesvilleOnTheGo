/// @description Write player specific game information
#region Game unique menu
#region Write the regular common UDP state update
// 3 is the offset for UDP messages, GAME_ID, connect_id, udp_sequence_out
buffer_seek(game_buffer, buffer_seek_start, 3)
// msg_id = SERVER_PLAY because client has already logged on
buffer_write(game_buffer, buffer_s8, SERVER_PLAY)
// state
buffer_write(game_buffer, buffer_u8, obj_menu.state)

var message_length = buffer_tell(game_buffer)
#endregion

var network_player_count = ds_list_size(client_connect_ids)  //get the amount of clients connected
for (var i=0; i<network_player_count; i++) {
	// obj_connected_client instances
	var Connected_client = ds_map_find_value(Connected_clients, client_connect_ids[| i])
	
	if not server_send_UDP(Connected_client, game_buffer, message_length)
		show_debug_message("Warning: UDP server message to client failed to send")
}

alarm[1] = game_update_wait
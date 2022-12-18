/// @description Ping all clients

//get the client message buffer
var buff = confirmBuffer
                        
//reset buffer to start - TCP message has a header of 2, GAME_ID and connect_id
buffer_seek(buff, buffer_seek_start, 2)

//write msg_id
buffer_write(buff, buffer_s8, SERVER_PING)

var length = buffer_tell(buff)

var network_player_count = ds_list_size(client_connect_ids)  //get the amount of clients connected
for (var i = 0; i < network_player_count; i++){
	//get the network player
	var Network_player = ds_map_find_value(Network_players, client_connect_ids[| i])
	
	//ensure that player is the main one for the client, and not extended
	if not Network_player.extended{
		//send new ping anyway
		//if client was in a state where it would not reply to a ping,
		//this new one would give it a chance to recover
		Network_player.waiting_on_reply = true
		scr_server_send_TCP(Network_player, buff, length)
	}
}

//save time ping happened for RTT calculation
ping_out = get_timer()

alarm[1] = seconds_between_pings*game_get_speed(gamespeed_fps)

/// @description Next screen
var network_player_count = ds_list_size(obj_server.active_connect_ids)
for (var i=0; i<network_player_count; i++){
	// obj_authoritative_player
	var Network_player = ds_map_find_value(obj_server.Network_players, obj_server.active_connect_ids[| i])
	// Actual game start message is handled in obj_server
	ds_queue_enqueue(Network_player.messages_out, SERVER_STATESWITCH)
}
if obj_menu.state == STATE_GAME{
	global.level++
}

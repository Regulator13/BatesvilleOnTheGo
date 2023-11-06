/// @description Close client

// Destroy network
network_destroy(tcp_client)

// Destroy all created persistent networking objects
// Players who are not active, are destroyed each iteration of scr_lobby_read
// These are first added in scr_update_lobby()
var _count = ds_list_size(active_connect_ids)
repeat(_count){
	// obj_network_player instances
	var Network_player = obj_client.Network_players[? active_connect_ids[| 0]]
	instance_destroy(Network_player)
}

// Destroy buffers after instances so they can still attempt to send any last images
// e.g. READY_UP when obj_character is destroyed
buffer_delete(message_buffer)

// Destroy lists
ds_map_destroy(Network_players)
ds_list_destroy(active_connect_ids)
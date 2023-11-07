/// @description Close server

// Destroy all created persistent networking objects
var _count = ds_list_size(active_connect_ids)
repeat(_count){
	// obj_connected_client instances
	var Connected_client = Connected_clients[? active_connect_ids[| 0]]
	instance_destroy(Connected_client)
}

// destroy server
global.have_server = false

//destroy network
network_destroy(tcp_server)
//destroy buffers to avoid memory leaks as restarting the game will not clear or delete a buffer
buffer_delete(game_buffer)
buffer_delete(action_buffer)

buffer_delete(confirm_buffer)

//destroy lists
ds_list_destroy(active_connect_ids)
ds_list_destroy(client_connect_ids)

//destroy maps
ds_map_destroy(Connected_clients)

file_text_close(global.message_log)
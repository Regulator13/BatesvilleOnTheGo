/// @description  Close server this is also called when a game restarts
// Destroy all created persistent networking objects
// Players who are not active, are dropped in obj_connected_client User Event 1
repeat(ds_list_size(active_connect_ids)){
	// obj_connected_client instances
	var Connected_client = Connected_clients[? active_connect_ids[| 0]]
	// This will remove the player from active_connect_ids as well as Connected_clients
	instance_destroy(Connected_client)
}

instance_destroy()
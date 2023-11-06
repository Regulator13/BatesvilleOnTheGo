/// @description Destroy data structures
if global.online {
	//remove from client's lists
	ds_list_delete(obj_client.active_connect_ids, ds_list_find_index(obj_client.active_connect_ids, connect_id))
	ds_map_delete(obj_client.Network_players, id)
}

instance_destroy(Player)
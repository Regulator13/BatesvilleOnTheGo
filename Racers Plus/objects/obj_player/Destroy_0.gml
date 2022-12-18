/// @description Destroy data structures
if obj_menu.state == STATE_LOBBY{
	//remove player from previous section
	if instance_exists(Section){
		var prev_index = ds_list_find_index(Section.Players, id)
		if prev_index != -1 ds_list_delete(Section.Players, prev_index)
	}
	if instance_exists(Name_box) instance_destroy(Name_box)
	if instance_exists(Ready_box) instance_destroy(Ready_box)
	if instance_exists(Color_box) instance_destroy(Color_box)
}

//remove from client's lists
if global.online{
	ds_list_delete(obj_client.active_connect_ids, ds_list_find_index(obj_client.active_connect_ids, connect_id))
	ds_map_delete(obj_client.Network_players, id)
}
/// @description Destroy data structures
ds_queue_destroy(messages_out)

if obj_menu.state == STATE_LOBBY{
	//remove player from previous section
	if instance_exists(Section){
		var prev_index = ds_list_find_index(Section.Players, id)
		if prev_index != -1 ds_list_delete(Section.Players, prev_index)
	}
}

// Remove from server Teams
var size = ds_map_size(obj_menu.Teams)
var key = ds_map_find_first(obj_menu.Teams)
for (var i = 0; i < size; i++;){
	var Team = obj_menu.Teams[? key]
	// Caution! Needs to be id and self
	var list_index = ds_list_find_index(Team.Players, id)
	if list_index != -1 {
		ds_list_delete(Team.Players, list_index)
	}
	key = ds_map_find_next(obj_menu.Teams, key)
}

//remove from lists
var i = ds_list_find_index(obj_server.active_connect_ids, connect_id)
ds_list_delete(obj_server.active_connect_ids, i)
var i = ds_list_find_index(obj_server.client_connect_ids, connect_id)
ds_list_delete(obj_server.client_connect_ids, i)
ds_map_delete(obj_server.Network_players, connect_id)

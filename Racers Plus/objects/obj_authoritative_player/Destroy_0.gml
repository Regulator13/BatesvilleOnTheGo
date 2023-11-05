/// @description Clean up
if obj_menu.state == STATE_LOBBY{
	//remove player from previous section
	if instance_exists(Section){
		var prev_index = ds_list_find_index(Section.Players, id)
		if prev_index != -1 ds_list_delete(Section.Players, prev_index)
	}
}

// Remove from server Teams
if instance_exists(obj_campaign) {
	var size = ds_map_size(obj_campaign.Teams)
	var key = ds_map_find_first(obj_campaign.Teams)
	for (var i = 0; i < size; i++;){
		var Team = obj_campaign.Teams[? key]
		// Caution! Needs to be id and self
		var list_index = ds_list_find_index(Team.Players, id)
		if list_index != -1 {
			ds_list_delete(Team.Players, list_index)
		}
		key = ds_map_find_next(obj_campaign.Teams, key)
	}
}
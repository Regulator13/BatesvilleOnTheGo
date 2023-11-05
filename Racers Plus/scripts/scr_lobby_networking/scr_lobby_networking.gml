/// @function update_player(connect_id, player_name, ready_to_start)
/// @description 
function update_player(connect_id, player_name, ready_to_start){
	// obj_network_player instances
	var Network_player = obj_client.Network_players[? connect_id]
	#region Add player to game
	if is_undefined(Network_player) {
		//add network player
		Network_player = instance_create_layer(0, 0, "lay_instances", obj_network_player)
		Network_player.connect_id = connect_id
		if connect_id == obj_client.connect_id{
			Network_player.local = true
		}
		
		if ds_map_add(obj_client.Network_players, connect_id, Network_player) {
			// ds_map_add returns true if the key does not already exist
			// If the key does exist, then this lobby was created after the score menu
			// and the client already has this as an active connect_id
			ds_list_add(obj_client.active_connect_ids, connect_id)
		}
		else{
			ds_map_replace(obj_client.Network_players, connect_id, Network_player)
		}
	}
	#endregion
	
	Network_player.player_name = player_name
	Network_player.ready_to_start = ready_to_start
	
	return Network_player
}
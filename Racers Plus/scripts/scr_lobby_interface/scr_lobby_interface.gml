function lobby_declare_interface_functions(){
	
	#region Networking
	write_state = function(buffer) {
		// Missions
		var mission_amount = array_length(missions)
		buffer_write(buffer, buffer_u8, mission_amount)
		for (var j=0; j<mission_amount; j++){
			missions[j].write_to_buffer(buffer)
		}
	
		// Sections & slots
		var section_amount = array_length(sections)
		buffer_write(buffer, buffer_u8, section_amount)
		for (var j=0; j<section_amount; j++){
			sections[j].write_to_buffer(buffer)
		}
		
		// Players
		// Do players last as they will join slots
		var player_amount = ds_list_size(obj_server.client_connect_ids) - 1
		buffer_write(buffer, buffer_u8, player_amount)
		for (var j=0; j<player_amount; j++) {
			var player = players[? obj_server.client_connect_ids[| j]]
			player.write_to_buffer(buffer)
		}
	}
	
	read_state = function(buffer) {
		// Missions
		var mission_amount = buffer_read(buffer, buffer_u8)
		for (var i=0; i<mission_amount; i++){
			missions[i] = stc_lobby_mission_read_from_buffer(buffer)
		}
		
		// Sections & slots
		var section_amount = buffer_read(buffer, buffer_u8)
		for (var i=0; i<section_amount; i++){
			sections[i] = stc_lobby_section_read_from_buffer(buffer)
		}
		
		// Players
		var player_amount = buffer_read(buffer, buffer_u8)
		for (var i=0; i<player_amount; i++){
			stc_lobby_section_read_from_buffer(buffer)
		}
	}
	
	// Regular UDP updates which don't require a synced interaction
	write_state_update = function(buffer) {
	}
	read_state_update = function(buffer) {	
	}
	#endregion
}
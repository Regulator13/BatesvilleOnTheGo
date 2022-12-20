////TODO
function controller_write_lobby(buff, starting_position, Player){
	//reset buffer to start - UDP messages have a 3 byte header, GAME_ID, connect_id, and udp_sequence_out
	buffer_seek(buff, buffer_seek_start, starting_position)
	
	buffer_write(buff, buffer_u8, Player.team)
	buffer_write(buff, buffer_u8, Player.player_color)
	buffer_write(buff, buffer_u8, Player.model)
	buffer_write(buff, buffer_string, Player.player_name)
	buffer_write(buff, buffer_bool, Player.ready_to_start)
	
	return buff
}

/// @function scr_write_lobby(buffer, buffer_tell)
/// @description Writes all lobby data from the server
//  Returns buffer with lobby info
function scr_write_lobby(buff, starting_position) {
	// write lobby data into new buffer
	
	//reset buffer to start - UDP messages have a 3 byte header, GAME_ID, connect_id, and udp_sequence_out
	buffer_seek(buff, buffer_seek_start, starting_position)
	
	//write map index
	buffer_write(buff, buffer_u8, obj_lobby.network_map_index)
	
	//write all sections
	var _length = ds_list_size(obj_lobby.Network_sections)
	buffer_write(buff, buffer_u8, _length)
	for (var i=1; i<_length; i++){
		var Section = obj_lobby.Network_sections[| i]
		if i != 0{
			buffer_write(buff, buffer_u8, Section.team)
			buffer_write(buff, buffer_u8, Section.spawn_color)
		}
		//write all players in this section
		var players_in_section = ds_list_size(Section.Players)
		buffer_write(buff, buffer_u8, players_in_section)
		for (var j=0; j<players_in_section; j++){
			var Player = Section.Players[| j]
			buffer_write(buff, buffer_u8, Player.connect_id)
			buffer_write(buff, buffer_string, Player.player_name)
			buffer_write(buff, buffer_bool, Player.ready_to_start)
			buffer_write(buff, buffer_u8, Player.player_color)
		}
	}
	//write default
	i = 0
	var Section = obj_lobby.Network_sections[| i]
	//write all players in this section
	var players_in_section = ds_list_size(Section.Players)
	buffer_write(buff, buffer_u8, players_in_section)
	for (var j=0; j<players_in_section; j++){
		var Player = Section.Players[| j]
		buffer_write(buff, buffer_u8, Player.connect_id)
		buffer_write(buff, buffer_string, Player.player_name)
		buffer_write(buff, buffer_bool, Player.ready_to_start)
		buffer_write(buff, buffer_u8, Player.player_color)
	}
	
	return buff
}

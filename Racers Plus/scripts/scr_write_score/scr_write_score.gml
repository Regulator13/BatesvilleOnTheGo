/// @function scr_write_score(buffer, buffer_tell)
/// @description Writes what should be displayed per player
//  Returns buffer with game info
function scr_write_score(buff, starting_position) {
	//reset buffer to start - UDP messages have a 3 byte header, GAME_ID, connect_id, and udp_sequence_out
	buffer_seek(buff, buffer_seek_start, starting_position)
	
    // Write team info and scores
	var size = ds_map_size(obj_campaign.Teams)
	buffer_write(buff, buffer_u8, size)
	
	var key = ds_map_find_first(obj_campaign.Teams)
	for (var i = 0; i < size; i++;){
		var Team = obj_campaign.Teams[? key]
		// Team details
		buffer_write(buff, buffer_u8, Team.team)
		buffer_write(buff, buffer_u16, Team.team_score)
		buffer_write(buff, buffer_u8, Team.team_color)
		
		// Team player details
		var _size = ds_list_size(Team.Players)
		buffer_write(buff, buffer_u8, _size)
		for (var j = 0; j < _size; j++){
			var Player = Team.Players[| j]
			buffer_write(buff, buffer_string, Player.player_name)
			buffer_write(buff, buffer_bool, Player.ready_to_start)
		}
		
	    key = ds_map_find_next(obj_campaign.Teams, key)
	}
	
	return buff
}

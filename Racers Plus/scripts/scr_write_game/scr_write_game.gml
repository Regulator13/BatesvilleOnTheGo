/// @function scr_write_game(buffer, buffer_tell, Authoritative_player)
/// @description Writes what should be displayed per player
//  Returns buffer with game info
function scr_write_game(buff, starting_position, Authoritative_player) {
	//reset buffer to start - UDP messages have a 3 byte header, GAME_ID, connect_id, and udp_sequence_out
	buffer_seek(buff, buffer_seek_start, starting_position)
	
    // Write common data

	#region Player specific section
	
	
	#endregion
	return buff
}

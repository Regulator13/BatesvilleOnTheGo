/// @function scr_record_turn(file)
/// @description Writes all the relevant data to a text file
//	Returns null
function scr_record_turn(file) {
	if file != -1{
		//write turn data
		var turn_info = scr_string_padded(obj_client.communication_turn, 4) + " " + scr_string_padded(ds_queue_head(obj_client.communication_turn_length), 2) + "@" + scr_string_padded(round(game_get_speed(gamespeed_fps)), 3) + " G" + scr_string_padded(game_step, 4) + " A" + scr_string_padded(global.step_counter, 4) + " : "
		file_text_write_string(file, turn_info)
	
		//add all relevant data to a single line
		var cur_state = ""
		
		file_text_write_string(file, cur_state)
		//write new line after each turn
		file_text_writeln(file)
	}
}

function scr_string_padded(str, length){
	str = string(str)
	while string_length(str) < length{
		str = str + " "
	}
	return str
}

function scr_record_pause(file) {
	if file != -1{
		//write turn data
		var turn_info = scr_string_padded("\|/ PAUSE \|/", 11) + " G" + scr_string_padded(game_step, 4) + " A" + scr_string_padded(global.step_counter, 4) + " : "
		file_text_write_string(file, turn_info)
	
		//add all relevant data to a single line
		var cur_state = ""
		
		//write new line after each turn
		file_text_writeln(file)
	}
}
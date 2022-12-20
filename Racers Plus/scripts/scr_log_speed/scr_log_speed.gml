/// @function scr_log_turn_speed(file, turn, prev_length, prev_speed, actual_turn_time, flag_factor)
/// @description Generates the map
function scr_log_turn_speed(file, prev_length, prev_speed, actual_turn_time, real_fps){
	if obj_client.record_logs{
		//round because rounded on server before sending out
		var ideal_fps = round(1000000/prev_speed)
		var actual_fps = round(scr_micro_to_fps(actual_turn_time/prev_length))
		scr_log(file, scr_string_padded(round(prev_speed/1000), 3) + ", " + scr_string_padded(round(actual_turn_time/prev_length/1000), 3) + ", " + scr_string_padded(ideal_fps, 3) + ", " + scr_string_padded(actual_fps, 3) + ", " + scr_string_padded(round(real_fps), 6))
	}
}

function scr_server_log_set(file, client_count, performance, average_millipf, milliseconds_off, lowest_performance, lowest_performance_client, most_milliseconds_off_server, most_milliseconds_off_client){
	if file != -1{
		scr_log(file, "--------------------")
		scr_log(file, "All clients have completed the set")

		//store who is the server client for calculating frames off from it
		var Server_client = ds_map_find_value(Network_players, client_connect_ids[| obj_client.connect_id])
	
		scr_log(file, "Act/Set off [ms]")
	
		var count = turns_per_set
		//have each turn in the set be a row
		for (var j=0; j<count; j++){
			var record = ""
			//have each client be a column
			for (var i = 0; i < client_count+1; i++) {
				if i < client_count{
					//get the network player of the client
					var Client = ds_map_find_value(Network_players, client_connect_ids[| i])
					//first and second actual millipf is always from the set before the last set
					if j < 2 {
						record = record + scr_string_padded(Client.last_set_actual_millipf[j], 3) + "/" + scr_string_padded(Client.prev_set_millipf, 3)
					}
					else{
						record = record + scr_string_padded(Client.last_set_actual_millipf[j], 3) + "/" + scr_string_padded(Client.set_millipf, 3)
					}
					if i != 0 record = record + " off " + scr_string_padded((Client.last_set_actual_millipf[j] - Server_client.last_set_actual_millipf[j])*last_set_turn_length[j], 4)
					record = record + " | "
				}
				else record = record + " was " + scr_string_padded(last_set_turn_length[j], 1) + " turns"
			}
			scr_log(file, record)
		}
	
		scr_log(file, "id: Avg Prfm <> Off")
		//show results for each client
		for (var i = 0; i < client_count; i++) {
			//get the network player of the client
			var Client = ds_map_find_value(Network_players, client_connect_ids[| i])
		
			scr_log(file, scr_string_padded(i, 2) + ": " + scr_string_padded(average_millipf[i], 3) + " " + scr_string_padded(performance[i], 4) + " <> +" + scr_string_padded(milliseconds_off[i], 3) + "=" + string(Client.milliseconds_off_server))
		}
	
		scr_log(file, "Results: ")
		scr_log(file, "Low Prfm. " + string(lowest_performance_client) + "@" + string(lowest_performance))
		scr_log(file, "Most Off. " + string(most_milliseconds_off_client) + "@" + string(most_milliseconds_off_server))
		scr_log(file, "--------------------")
	}
}

function scr_server_log_set_calcs(file, base_speed, communication_turn_speed, max_change){
	if file != -1{
		scr_log(file, "Base speed: " + string(base_speed) + " Communication turn speed: " + string(communication_turn_speed) + " Max Change: " + string(max_change))
		//get the amount of clients connected
		var client_count = ds_list_size(client_connect_ids)
		for (var i = 0; i < client_count; i++) {
			//get the network player of the client
			var Client = ds_map_find_value(Network_players, client_connect_ids[| i])
			var record = scr_string_padded(Client.connect_id, 2) + ": " + scr_string_padded(Client.set_millipf, 3) + " from " + scr_string_padded(Client.prev_set_millipf, 3) + " min: " + scr_string_padded(Client.min_millipf, 3)
		
			scr_log(file, record)
		}
		scr_log(file, "--------------------")
	}
}

function scr_server_log_set_csv(file){
	if file != -1{
		//file_text_write_string(file, "Lowest performance: " + string(lowest_performance_client) + " Most milliseconds off: " + string(most_frames_off_client))
		//write new line after each turn
		//file_text_writeln(file)
		for (var j=0; j<turns_per_set; j++){
			var record = ""//scr_string_padded(base_speed, 3)
	
			//get the amount of clients connected
			var client_count = ds_list_size(client_connect_ids)
			for (var i = 0; i < client_count; i++) {
				//get the network player of the client
				var Client = ds_map_find_value(Network_players, client_connect_ids[| i])
				if j < 2 record = record + "," + scr_string_padded(round(scr_milli_to_fps(Client.prev_set_millipf)), 3)
				else record = record + "," + scr_string_padded(round(scr_milli_to_fps(Client.set_millipf)), 3)
				record = record + "," + scr_string_padded(round(scr_milli_to_fps(Client.last_set_actual_millipf[j])), 3)
				if j < 2 record = record + "," + scr_string_padded(Client.prev_set_millipf, 3)
				else record = record + "," + scr_string_padded(Client.set_millipf, 3)
				record = record + "," + scr_string_padded(Client.last_set_actual_millipf[j], 3) + "," + scr_string_padded(last_set_turn_length[j], 3) 
			}
			file_text_write_string(file, record)
			//write new line after each turn
			file_text_writeln(file)
		}
	}
}

function scr_server_log_turn_speed_calcs(file){
	if file != -1{
		file_text_write_string(file, "Base speed: " + string(base_speed) + " Communication speed: " + string(communication_turn_speed))
		file_text_writeln(file)
		//get the amount of clients connected
		var client_count = ds_list_size(client_connect_ids)
		for (var i = 0; i < client_count; i++) {
			//get the network player of the client
			var Client = ds_map_find_value(Network_players, client_connect_ids[| i])
			var record = "Client " + string(Client.connect_id) + ", " + string(Client.set_millipf) + ", " + scr_string_padded(Client.milliseconds_off_server, 2) + "," + scr_string_padded(Client.performance, 4)
		
			file_text_write_string(file, record)
			//write new line after each turn
			file_text_writeln(file)
		}
	}
}

function scr_server_log_speed_wait(file, connect_id, client_set_turn, server_set_turn){
	if file != -1{
		file_text_write_string(file, "Waiting: " + string(connect_id) + " on " + string(client_set_turn) + " while server is on " + string(server_set_turn))
		file_text_writeln(file)
	}
}

function scr_log(file, record){
	if file != -1{
		file_text_write_string(file, record)
		file_text_writeln(file)
	}
}

function scr_micro_to_fps(microseconds){
	return 1000000/microseconds
}

function scr_milli_to_fps(microseconds){
	return 1000/microseconds
}

function scr_adjust_millipf_to(from, to, max_change){
	var change = to - from
	if change > max_change change = max_change
	if change < -max_change change = -max_change
	//keep in bounds
	if from + change < max_millipf return max_millipf
	else return from + change
}


/// @function scr_one_turn_set_method()
function scr_every_turn_set_method(){
	//this script contains the speed control method of using sets and adjusting every turn within the set
	//to make up for the time differences in the last set
	var pause_server = false
	
	#region Calculate new millipf every set
	if set_turn == turns_per_set{
		//get the amount of clients connected
		var client_count = ds_list_size(client_connect_ids)
	
		//measure performance by whether client can match set millipf
		//this is measured set by set
		var performance = array_create(client_count, 1)
		var average_millipf = array_create(client_count)
		var milliseconds_off_change = array_create(client_count)
		//keep track of who is performing the worst
		//if no client is performing worst than this value than bump up the speed
		var lowest_performance = 1.2
		var lowest_performance_client = -1
		var most_milliseconds_off = 30
		var most_milliseconds_off_client = -1
		var most_milliseconds_off_change = 0
		//store who is the server client for calculating frames off from it
		var Server_client = ds_map_find_value(Network_players, client_connect_ids[| obj_client.connect_id])
	
		for (var i = 0; i < client_count; i++) {
			//get the network player of the client
			var Client = ds_map_find_value(Network_players, client_connect_ids[| i])
		
			//ensure that the client has completed the previous set
			if Client.set_complete{
				//average the precentages of the actual to the set millipf for performance
				//and get the frames off from the server
				var total_average = 0
				var total_performance = 0
				var count = turns_per_set
				for (var j=0; j<count; j++){
					//first and second actual millipf is always from the set before the last set
					if j < 2 total_performance += (Client.last_set_actual_millipf[j]/Client.prev_set_millipf)
					else {
						//after the first two terms the millipf are set from the latest set calculation
						total_performance += (Client.last_set_actual_millipf[j]/Client.set_millipf)
						total_average += Client.last_set_actual_millipf[j]
					}
					//get how many more milliseconds the client is off from the server with this turn
					milliseconds_off_change[i] += (Client.last_set_actual_millipf[j] - Server_client.last_set_actual_millipf[j])*last_set_turn_length[j]
				}
				average_millipf[i] = round(total_average/(count - 2))
				performance[i] = total_performance/count
				Client.performance = performance[i]
				Client.milliseconds_off_server += milliseconds_off_change[i]
		
				//check if lowest performing client so far
				if performance[i] > lowest_performance{
					lowest_performance = performance[i]
					lowest_performance_client = i
				}
				//flag if client has the most off the server
				if abs(Client.milliseconds_off_server) > abs(most_milliseconds_off){
					most_milliseconds_off = Client.milliseconds_off_server
					most_milliseconds_off_client = i
				}
				if abs(milliseconds_off_change[i]) > abs(most_milliseconds_off_change){
					most_milliseconds_off_change = milliseconds_off_change[i]
				}
			}
			else{
				//not all clients have completed the set, pause the game and wait for the client
				ds_list_add(waiting_on_clients, Client.connect_id)
				pause_server = true
				scr_log(server_speed_log, "Waiting on " + string(Client.connect_id))
			}
		}
	
		//log speed control data
		if not pause_server{
			scr_server_log_set(server_speed_log, client_count, performance, average_millipf, milliseconds_off_change, lowest_performance, lowest_performance_client, most_milliseconds_off, most_milliseconds_off_client)
			scr_server_log_set_csv(server_speed_data)
		}
		else scr_log(server_speed_log, "Set complete, but waiting on a client")
	
		if not pause_server{
			if abs(most_milliseconds_off_change) < 50{
				scr_log(server_speed_log, "Small enough (" + string(most_milliseconds_off_change) + ") millisecond change. Keeping previous speeds.")
				if abs(most_milliseconds_off) > 100{
				var millisecond_off_adjustment = round((most_milliseconds_off/turns_per_set)/communication_turn_length)
					var Client = ds_map_find_value(Network_players, client_connect_ids[| most_milliseconds_off_client])
					var max_change = round(abs(most_milliseconds_off)/25)
					var record = scr_string_padded(Client.connect_id, 2) + ": " + scr_string_padded(Client.set_millipf, 3) + " -> "
					Client.set_millipf = scr_adjust_millipf_to(Client.set_millipf, base_speed - millisecond_off_adjustment, max_change)
					if Client.set_millipf < max_millipf Client.set_millipf = max_millipf
					record = record + scr_string_padded(base_speed - millisecond_off_adjustment, 3) + " ^ " + scr_string_padded(max_change, 3) + " = " + scr_string_padded(Client.set_millipf, 3)
					scr_log(server_speed_log, record)
				 }
				 
				 //set new millipf for each client to be sent over
				for (var i = 0; i < client_count; i++) {
					//get the network player of the client
					var Client = ds_map_find_value(Network_players, client_connect_ids[| i])
		
					//reset the set complete flag since a new set is beginning
					Client.set_complete = false
				}
			}
			else{
				//max change in millipf
				var max_change = 4
			
				//check if every client can perform at the speed
				if (lowest_performance_client == -1 and most_milliseconds_off_client == -1){
					//move towards slowest client highest av
					//bump up the speed based on the previous base speed
					base_speed = scr_adjust_millipf_to(base_speed, base_speed - round((base_speed - max_millipf)/2), max_change)
					if base_speed < max_millipf base_speed = max_millipf
					communication_turn_speed = base_speed 
				}
				else{
					//Caution! This uses an estimate that the following turns will be the same length of steps as the previous ones
					//we do not want to change per turn because we want to limit gamespeed changes
					var millisecond_off_adjustment = round((most_milliseconds_off/turns_per_set)/communication_turn_length)
					if most_milliseconds_off_client != -1{
						//a client is far behind, but can keep up with the set millipf
						max_change = round(abs(most_milliseconds_off)/25)
						if most_milliseconds_off > 0{
						
						}
						else{
						
						}
						//adjust server speed
						if milliseconds_off_change[most_milliseconds_off_client] > 0{
							//need to increase milliseconds per frame of server so that the client to try and recover
							base_speed = average_millipf[most_milliseconds_off_client]
							//client is falling further behinde
							communication_turn_speed = base_speed + millisecond_off_adjustment
						}
						else{
							//client is catching up
							communication_turn_speed = base_speed - most_milliseconds_off_client
							//work toward client's max fps
							var Client = ds_map_find_value(Network_players, client_connect_ids[| most_milliseconds_off_client])
							base_speed = Client.min_millipf
						}
					}
					else{
						//determine base speed as the worst performing client
						base_speed = average_millipf[lowest_performance_client]
	
						//set millipf of server to account for how far the slowest client is behind in the next step
						//difference is negative if client is behind
						var Client = ds_map_find_value(Network_players, client_connect_ids[| lowest_performance_client])
						//only try to account for half the discrepency at a time
						communication_turn_speed = base_speed + round(Client.milliseconds_off_server/2/turns_per_set)
					}
				}
	
				//set new millipf for each client to be sent over
				for (var i = 0; i < client_count; i++) {
					//get the network player of the client
					var Client = ds_map_find_value(Network_players, client_connect_ids[| i])
		
					//reset the set complete flag since a new set is beginning
					Client.set_complete = false
		
					Client.prev_set_millipf = Client.set_millipf
				
					//log calculations
					var record = scr_string_padded(Client.connect_id, 2) + ": " + scr_string_padded(Client.set_millipf, 3) + " -> "
			
					//four cases to consider
					switch(i){
						case obj_client.connect_id:
							//server client speed set to slow down for client
							Client.set_millipf = scr_adjust_millipf_to(Client.set_millipf, communication_turn_speed, max_change)
							record = record + scr_string_padded(communication_turn_speed, 3) + " ^ " + scr_string_padded(max_change, 3) + " = " + scr_string_padded(Client.set_millipf, 3)
							break
						case most_milliseconds_off_client:
		 					Client.set_millipf = scr_adjust_millipf_to(Client.set_millipf, base_speed - millisecond_off_adjustment, max_change)
							record = record + scr_string_padded(base_speed - millisecond_off_adjustment, 3) + " ^ " + scr_string_padded(max_change, 3) + " = " + scr_string_padded(Client.set_millipf, 3)
							break
						case lowest_performance_client:
							//lowest performing client to use base speed it determined
							Client.set_millipf = scr_adjust_millipf_to(Client.set_millipf, base_speed, max_change)
							record = record + scr_string_padded(base_speed, 3) + " ^ " + scr_string_padded(max_change, 3) + " = " + scr_string_padded(Client.set_millipf, 3)
							break
						default:
							//all other clients must try to match the server
							//adjust for how many frames off the client will be to the server with the new speed
							Client.set_millipf = scr_adjust_millipf_to(Client.set_millipf, communication_turn_speed + round(Client.milliseconds_off_server/turns_per_set), max_change)
							record = record + scr_string_padded(communication_turn_speed + round(Client.milliseconds_off_server/turns_per_set), 3) + " ^ " + scr_string_padded(max_change, 3) + " = " + scr_string_padded(Client.set_millipf, 3)
							break
					}
			
					//keep millipf in bound of 1-255
					if Client.set_millipf < 5 {
						Client.set_millipf = 5
					}
					else if Client.set_millipf > 255 Client.set_millipf = 255
					
					//log calc
					scr_log(server_speed_log, record)
				}
				
				scr_server_log_set_calcs(server_speed_log, base_speed, communication_turn_speed, max_change)
			}
	
			set_turn = 0
		}
	}
	else set_turn++
	#endregion
	
	return pause_server
}
/// @function scr_wait_on_set_method()
function scr_wait_on_set_method(){
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
			//set new millipf for each client to be sent over
			for (var i = 0; i < client_count; i++) {
				//get the network player of the client
				var Client = ds_map_find_value(Network_players, client_connect_ids[| i])
				
				//reset the set complete flag since a new set is beginning
				Client.set_complete = false
				
				Client.prev_set_millipf = Client.set_millipf
			}
	
			set_turn = 0
		}
	}
	else set_turn++
	#endregion
	
	return pause_server
}
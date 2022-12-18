/// @function scr_one_turn_set_method()
function scr_one_turn_set_method(){
	//this script contains the speed control method of using sets and adjusting one turn for time make up
	var pause_server = false

	#region Calculate new millipf every set
	if set_turn == turns_per_set{
		//keep track of who is performing the worst
		//if no client is performing worst than this value than bump up the speed
		//performance factor determines what percentage of increase in processing time is too much
		var performance_factor = 1.2
		var lowest_performance = performance_factor
		var lowest_performance_client = -1
		var most_milliseconds_off_server = 30
		var most_milliseconds_off_client = -1
		
		//get the amount of clients connected
		var client_count = ds_list_size(client_connect_ids)
		
		//measure performance by whether client can match set millipf
		//this is measured set by set
		var performance = array_create(client_count, 1)
		var average_millipf = array_create(client_count, 1)
		
		//store who is the server client for calculating frames off from it
		//done every set because the client might complete the set turn before the server has data to compare
		var Server_client = ds_map_find_value(Network_players, client_connect_ids[| obj_client.connect_id])
	
		for (var i = 0; i < client_count; i++){
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
					total_average += Client.last_set_actual_millipf[j]
					//first and second actual millipf is always from the last set
					if j < 2 total_performance += (Client.last_set_actual_millipf[j]/Client.prev_set_millipf)
					else total_performance += (Client.last_set_actual_millipf[j]/Client.set_millipf)
					//get how many more frames the client is off from the server with this turn
					Client.milliseconds_off_server += (Client.last_set_actual_millipf[j] - Server_client.last_set_actual_millipf[j])*last_set_turn_length[j]
				}
				average_millipf[i] = round(total_average/count)
				performance[i] = total_performance/count
				Client.performance = performance[i]
		
		//if this client cannot keep up its set speed,
					//and is averaging at a speed below the previous base,
					//make new base speed
					if average_millipf[i] > base_speed or Client.milliseconds_off_server > 100{
						base_speed = round(average_millipf[i])
						slowest_client = i
					}
				//check if lowest performing client so far
				if performance[i] > lowest_performance{
					lowest_performance = performance[i]
					lowest_performance_client = i
					
				}
				//check it it has more frames off the server
				if abs(Client.milliseconds_off_server) > abs(most_milliseconds_off_server){
					most_milliseconds_off_server = Client.milliseconds_off_server
					most_milliseconds_off_client = i
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
		scr_server_log_turn_speed(server_speed_log, lowest_performance_client, most_milliseconds_off_client)
	
		if not pause_server{
			/*
			//check if every client can perform at the speed
			if (lowest_performance_client == -1 and most_milliseconds_off_client == -1){
				//bump up the speed based on the previous base speed
				base_speed = scr_adjust_millipf_to(base_speed, base_speed - round((base_speed - max_millipf)/2))
				if base_speed > max_millipf base_speed = max_millipf
				communication_turn_speed = base_speed 
			}
			else{
				if most_milliseconds_off_client != -1{
					//a client is far behind, but can keep up with the set millipf
					//need to decrease milliseconds per frame just for this client to try and recover
					base_speed = average_millipf[most_milliseconds_off_client]
					//will also adjust server speed to accomodate
					communication_turn_speed = base_speed + round(most_milliseconds_off_server/turns_per_set)
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
			*/
			//set new millipf for each client to be sent over
			for (var i = 0; i < client_count; i++) {
				//get the network player of the client
				var Client = ds_map_find_value(Network_players, client_connect_ids[| i])
		
				//reset the set complete flag since a new set is beginning
				Client.set_complete = false
		
				Client.prev_set_millipf = Client.set_millipf
				
				if i != slowest_client Client.set_millipf = base_speed
				else {
					if Client.milliseconds_off_server > 100{
						Client.set_millipf = base_speed/1.2
					}
					else{
						//Client.set_millipf = base_speed
						base_speed = base_speed/1.2
						slowest_client = -1
					}
				}
			
				//four cases to consider
				/*
				switch(i){
					case obj_client.connect_id:
						//server client speed set to slow down for client
						Client.set_millipf = scr_adjust_millipf_to(Client.set_millipf, communication_turn_speed)
						break
					case most_milliseconds_off_client:
	 					Client.set_millipf = scr_adjust_millipf_to(Client.set_millipf, base_speed - round(most_milliseconds_off_server/turns_per_set))
						break
					case lowest_performance_client:
						//lowest performing client to use base speed it determined
						Client.set_millipf = scr_adjust_millipf_to(Client.set_millipf, base_speed)
						break
					default:
						//all other clients must try to match the server
						//adjust for how many frames off the client will be to the server with the new speed
						Client.set_millipf = scr_adjust_millipf_to(Client.set_millipf, communication_turn_speed + round(Client.milliseconds_off_server/turns_per_set))
						break
				}
				*/
			
				//keep millipf in bound of 1-255
				if Client.set_millipf < 5 {
					Client.set_millipf = 5
				}
				else if Client.set_millipf > 255 Client.set_millipf = 255
			}
	
			set_turn = 0
		
			scr_server_log_turn_speed_calcs(server_speed_log)
		}
	}
	else set_turn++
	#endregion
	return pause_server
}
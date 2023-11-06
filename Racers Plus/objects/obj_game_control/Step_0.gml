/// @description Game win conditions

if os_browser == browser_not_a_browser and (not global.online or global.have_server){
	// Check win conditions
	if winner == 0{
		// Win/lose by score
		/* TODO
		for (var i=0; i<instance_number(obj_group); i++){
			var Team = instance_find(obj_group, i)
			if abs(Team.team_score) > win_score{
				show_debug_message("Win! Score " + string(Team.team_score))
				winner = i
				change_state = true
			}
		}
		
	
		// Check if all customers same team
		var all_loyal_to_one_team = true
		var Customer = global.customer_locations[| 0]
		var team_to_check = Customer.loyal_team
		for (var i=1; i<customer_amount; i++){
			var Customer = global.customer_locations[| i]
			if Customer.loyal_team != team_to_check{
				all_loyal_to_one_team = false
				break
			}
		}
	
		if all_loyal_to_one_team{
			show_debug_message("Win! All customers loyal to one team")
			winner = team_to_check
			change_state = true
		}
		*/
	}

	//change state
	if (change_state) {
		if not global.online {
		
		}
		else {
			//inform clients game is starting
			for (var i = 0; i < ds_list_size(obj_server.active_connect_ids); i++){
				//get the network player
				var Connected_client = ds_map_find_value(obj_server.Connected_clients, obj_server.active_connect_ids[| i])
				//actual game start message is handled in obj_server
				ds_queue_enqueue(Connected_client.messages_out, SERVER_STATESWITCH)
			}
		}
	
		// Ensure multiple messages are not queued
		change_state = false
	}
}

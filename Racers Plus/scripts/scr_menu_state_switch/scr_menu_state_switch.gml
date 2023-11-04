/// @function scr_state_switch(from, to)
/// @description switches the current menu state to the new state
/// @param from
/// @param to
function menu_state_switch(argument0, argument1) {
	// Returns null

	// set input
	var from = argument0;
	var to = argument1;

	// switch menu state
	with (global.Menu) {
		//check if going back one state
		if ds_stack_top(state_queue) = to
			ds_stack_pop(state_queue)//delete last entry
		else
			ds_stack_push(state_queue, from)//add new entry
	
		//reset button selection to 0
		selected = 0
		//io_clear to prevent keystrokes from carrying to next menu
		io_clear()
	
		//set state
		state = to;

		//switch state
	    switch (from) {
	        case STATE_ONLINE:
	            switch (to) {
	                case STATE_LOBBY:
						global.level = 0
						// Ensure all previous teams are cleared
						ds_map_clear(obj_menu.Teams)
						
						if os_browser == browser_not_a_browser{
							room_goto(mnu_lobby)
						}
						else{
							room_goto(mnu_controller_lobby)
						}
	                    break
				}
	            break;
			case STATE_LOBBY:
	            switch (to) {
	                case STATE_GAME:
						if os_browser == browser_not_a_browser{
							room_goto(obj_lobby.Map.room_index)
						}
						else{
							// Just because it is blank
							instance_create_layer(0, 0, "lay_instances", obj_game_control)
							room_goto(mnu_controller_score)
						}
	                    break
					case STATE_SCORE:
						// Universal back button will lead to state score,
						// but should just quit to main
						state = STATE_MAIN
						// Break statement intentionally omitted
					case STATE_ONLINE:
						// Destroy lobby first to save player name
						instance_destroy(obj_lobby)
	                    if (global.have_server) // check if hosting
	                        instance_destroy(obj_server)
	                    instance_destroy(obj_client)
						
						if os_browser == browser_not_a_browser{
							room_goto(mnu_main)
						}
						else{
							room_goto(mnu_controller_main)
						}
						break
				}
	            break;
			case STATE_GAME:
				instance_destroy(obj_game_control)
				
	            switch (to) {
					case STATE_SCORE:
						// Reset start so it can be checked for again
						obj_menu.start = false
						
	                    // goto menu screen
	                    if os_browser == browser_not_a_browser{
							room_goto(mnu_score)
						}
						else{
							room_goto(mnu_controller_score)
						}
						
						// Score menu is initiated in obj_menu Room Start Event
						// to deal with the change of rooms
						
	                    break
					case STATE_ONLINE:
						if os_browser == browser_not_a_browser{
							room_goto(mnu_main)
						}
						else{
							room_goto(mnu_controller_main)
						}
						// destroy online objects
	                    if (global.have_server) // check if hosting
	                        instance_destroy(obj_server)
	                    instance_destroy(obj_client)
						break
				}
				break
			 case STATE_SCORE:
	            switch (to) {
	                case STATE_LOBBY:
						// Reset start so it can be checked for again
						obj_menu.start = false
						
						if os_browser == browser_not_a_browser{
							room_goto(mnu_lobby)
						}
						else{
							room_goto(mnu_controller_lobby)
						}
                    
	                    break
	                case STATE_MAIN:
	                    // goto menu screen
	                    room_goto(mnu_main)
                    
	                    // destroy online objects
	                    if (global.have_server) // check if hosting
	                        instance_destroy(obj_server)
	                    instance_destroy(obj_client)
						
	                    break
					case STATE_ONLINE:
						// Menu is initialized in Room Start even of obj_menu
	                    room_goto(mnu_main)
                    
	                    // destroy online objects
	                    if (global.have_server)
	                        instance_destroy(obj_server)
	                    instance_destroy(obj_client)
						
	                    break
	            }
	            break
	    }
		show_debug_message("scr_state_switch from " + scr_state_to_string(from) + " to " + scr_state_to_string(to))
	}



}

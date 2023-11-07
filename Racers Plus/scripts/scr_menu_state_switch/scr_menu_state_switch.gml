/// @function  menu_state_switch(from, to)
/// @descrption  Switches the current menu state to the new state
/// @param  from
/// @param  to
function menu_state_switch(from, to){
	obj_controls.state_switch(from, to)
	// Destroy any input messages that may have been ignored
	// but have specific to state commands
	instance_destroy(obj_input_message)
	
	// switch menu state
	with (obj_menu) {
		scr_menu_clear()
		
		//check if going back one state
		if ds_stack_top(state_queue) = to
			ds_stack_pop(state_queue)//delete last entry
		else
			ds_stack_push(state_queue, from)//add new entry

		//set state
		state = to

		//switch state
	    switch (from) {
			case STATE_MAIN:
	            switch (to) {
					case STATE_ONLINE:
	                    // initiate menu
	                    menu_init(to)
					
						break
					case STATE_GAME:
						// Tutorial/campaign
						break
	            }
				break
	        case STATE_ONLINE:
	            switch (to) {
	                case STATE_LOBBY:
						// Campaign initializes interactable_ids
						instance_create_layer(0, 0, "lay_instances", obj_campaign)
						instance_create_layer(0, 0, "lay_instances", obj_lobby)
						
						menu_init(to)
	                    break
					case STATE_MAIN:
	                    instance_destroy(obj_online)
						
						// go offline
						global.online = false
                    
	                    // initiate main menu
	                    menu_init(to)
	                    break
				}
	            break;
			case STATE_LOBBY:
	            switch (to) {
					case STATE_SCORE:
						// Universal back button will lead to state score,
						// but should just quit to main
						state = STATE_MAIN
						// Break statement intentionally omitted
					case STATE_ONLINE:
						instance_destroy(obj_campaign)
						// Destroy lobby first to save player name
						instance_destroy(obj_lobby)
	                    if (global.have_server) // check if hosting
	                        instance_destroy(obj_server)
						
						room_goto(mnu_main)
						break
				}
	            break;
			case STATE_GAMECONFIG:
	            switch (to) {
					case STATE_GAME:
						room_goto(obj_campaign.mission.Map.room_index)
						break
					case STATE_ONLINE:
	                    break
				}
				break
			case STATE_GAME:
				instance_destroy(obj_game_control)
				
	            switch (to) {
					case STATE_SCORE:
						// Reset start so it can be checked for again
						obj_menu.start = false
						
						room_goto(mnu_score)
						
						// Score menu is initiated in obj_menu Room Start Event
						// to deal with the change of rooms
						
	                    break
					case STATE_ONLINE:
						// Called by obj_input_message upon server connection loss
						instance_destroy(obj_campaign)
						
						room_goto(mnu_main)
						
						// destroy online objects
	                    if (global.have_server) // check if hosting
	                        instance_destroy(obj_server)
	                    
						break
					case STATE_MAIN:
						// Menu is initialized in Room Start even of obj_menu
	                    room_goto(mnu_main)
						
						// destroy online objects
	                    if (global.have_server) // check if hosting
	                        instance_destroy(obj_server)
						
						instance_destroy(obj_campaign)
						
	                    break
				}
				break
			 case STATE_SCORE:
	            switch (to) {
	                case STATE_LOBBY:
						instance_create_layer(0, 0, "lay_instances", obj_lobby)
						
						menu_init(to)
                    
	                    break
	                case STATE_MAIN:
	                    // goto menu screen
	                    room_goto(mnu_main)
                    
	                    // destroy online objects
	                    if (global.have_server) // check if hosting
	                        instance_destroy(obj_server)
						
						instance_destroy(obj_campaign)
						
	                    break
					case STATE_ONLINE:
						// Menu is initialized in Room Start even of obj_menu
	                    room_goto(mnu_main)
                    
	                    // destroy online objects
	                    if (global.have_server)
	                        instance_destroy(obj_server)
						
						instance_destroy(obj_campaign)
						
	                    break
	            }
	            break
	    }
	}

	with obj_campaign state_switch(from, to)
	with obj_lobby state_switch(from, to)
}

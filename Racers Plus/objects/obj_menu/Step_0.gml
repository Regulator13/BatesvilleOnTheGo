/// @description Input
#region Local input, menus, Buttons
//check if game is paused
if !(instance_exists(obj_input_message)){
    var haxis = 0; //left or right
    var vaxis = 0; //up or down
    var action = false; //clicking
    var input; //gamepad input
    var axis_buffer = GAMEPAD_AXIS_TOL; //buffer till push starts counting
    
    //get input
    if (input_buffer < 0){
        //judge input based on current state
        switch(state){
            case STATE_GAME:
                break //no menu
            default: //other menus
				#region Get input
				//gamepad input
		        for (input = 0; input < 4; input++) {
		            var chaxis = gamepad_axis_value(input, gp_axislh);
		            var cvaxis = gamepad_axis_value(input, gp_axislv);
			
		            // axis check
		            if (chaxis > axis_buffer or chaxis < -axis_buffer) haxis = 1*sign(chaxis)
		            if (cvaxis > axis_buffer or cvaxis < -axis_buffer) vaxis = 1*sign(cvaxis)
			
		            // action
		            if(gamepad_button_check_released(input, gp_face1)) action = true;
		        }
        
		        //keyboard input
				if keyboard_check(vk_anykey) keyboard_input = true; //show selection via keyboard
				if mouse_x != prev_mouse_x{
					if keyboard_input == 1{
						keyboard_input = 2 //reset button click
					}
					prev_mouse_x = mouse_x
				}
		        if (keyboard_check(vk_left) or keyboard_check(ord("A")) or keyboard_check(ord("J"))) haxis = -1;
		        if (keyboard_check(vk_right) or keyboard_check(ord("D")) or keyboard_check(ord("L"))) haxis = 1;
		        if (keyboard_check(vk_up) or keyboard_check(ord("W")) or keyboard_check(ord("I"))) vaxis = -1;
		        if (keyboard_check(vk_down) or keyboard_check(ord("S")) or keyboard_check(ord("K"))) vaxis = 1;
		        if (keyboard_check_pressed(vk_enter)) action = true;  
        
				// reset buffer if got input
		        if (haxis != 0 or vaxis != 0 or action != false){
		            input_buffer = input_buffer_max;
				}
				#endregion
				
				#region Default
	            //Selector
	            if (ds_list_size(Buttons) > 0){
//					show_debug_message("obj_menu.Step buttons size: " + string(ds_list_size(buttons)))
//						show_debug_message("obj_menu.Step selected: " + string(selected))
					//button controls
					var button = ds_list_find_value(Buttons, selected);
					
					//if on value button limit changes of selection to only down and up to allow left and right to change value
	                if (instance_exists(button)){
//						show_debug_message("obj_menu.Step Button exists")
						//show button as selected
						if keyboard_input == 1{
							button.image_index = 1
						}
						else if keyboard_input == 2{
							button.image_index = 0
							keyboard_input = false
						}
							
						if haxis != 0 or vaxis != 0{
							//no longer show button as selected
							button.image_index = 0
							if (button.action == "value" or button.action == "valueAction"){
								selected = scr_increment_in_bounds(selected, vaxis, 0, ds_list_size(Buttons)-1, true);
							}
							else{
			                    selected = scr_increment_in_bounds(selected, haxis+vaxis, 0, ds_list_size(Buttons)-1, true);
							}
						}
						
			            if (button.action == "value") {
			                button.value = scr_increment_in_bounds(button.value, haxis, 0, ds_list_size(button.values)-1, true);
			            }
					
			            else if (button.action == "valueAction") {
			                button.value = scr_increment_in_bounds(button.value, haxis, 0, ds_list_size(button.values)-1, true);
			                // if value changed do action
			                if (haxis != 0)
			                    with (button) event_user(1);
			            }
					
			            // press button
			            if (action) {
			                with (button) {
								//perform the button's action
			                    event_user(0);
			                }
			            }
					}
					//else allow any direction to change selected button
	                else{
	                    selected = scr_increment_in_bounds(selected, haxis+vaxis, 0, ds_list_size(Buttons)-1, true);
					}
					
	            }
				//else allow any direction to change selected button
				else{
	                selected = scr_increment_in_bounds(selected, haxis+vaxis, 0, ds_list_size(Buttons)-1, true);
				}
//				show_debug_message("obj_menu.Step pso tselected: " + string(selected))
				#endregion
				break
        }
    }
	
    else input_buffer--;
}
#endregion

#region Lobby server input
if global.online and global.have_server {
	switch state{
		case STATE_LOBBY:
			//adding psuedo players for debug
			/*
			if keyboard_check_released(ord("B")){
				//connect psuedo player to server
				with obj_server{
					var connect_id = global.connect_id++
					var Network_player = scr_connect_client(connect_id, -1, -1, -1)
					//automatically set player as ready to start
					Network_player.player_name = "Extended"
					Network_player.ready_to_start = true
					Network_player.extended = true
					//Network_player.team = 2
				}
			}
			*/
			// break statement is intentionally left out
		case STATE_SCORE:
			#region Update readys for network players and start game
			var Host = obj_server
			var network_player_count = ds_list_size(Host.active_connect_ids)
			// obj_menu.start is reset in scr_state_switch
		    if (not start and network_player_count > 1) {
		        //check for start
		        start = true//set to false if a player is not ready
                
		        //check if any player is not ready
				// TODO Exclude host
		        for (var i = 1; i < network_player_count; i++){
					//get the network player
					var Network_player = ds_map_find_value(Host.Network_players, Host.active_connect_ids[| i])
					if not Network_player.ready_to_start
						start = false
		        }
                
		        //start if all are ready
		        if (start) {
		            //start game
		            show_debug_message("All ready!")
                    
		            //inform clients game is starting
					for (var i = 0; i < network_player_count; i++){
						//get the network player
						var Network_player = ds_map_find_value(Host.Network_players, Host.active_connect_ids[| i])
						//actual game start message is handled in obj_server
						ds_queue_enqueue(Network_player.messages_out, SERVER_STATESWITCH)
					}
					
					if state == STATE_LOBBY{
						
						// Setup teams
						// Get the authoritative player through the lobby sections
						var count = ds_list_size(obj_lobby.Sections)
						for (var i=0; i<count; i++){
							var Section = obj_lobby.Sections[| i]
								
							// Update the team tracker object for this section
							if is_undefined(obj_menu.Teams[? Section.team]) {
								obj_menu.Teams[? Section.team] = instance_create_layer(0, 0, LAY, obj_team)
							}
							var Team = obj_menu.Teams[? Section.team]
							Team.team = Section.team
							if Section.section_type != DEFAULT_SECTION{
								Team.team_color = Section.Color_box.field
							}
							// Always clear out the player list before adding new ones
							ds_list_clear(Team.Players)
								
							// Update authoritative players on the server
							var _count = ds_list_size(Section.Players)
							for (var j=0; j<_count; j++){
								var Player = Section.Players[| j]
								var Authoritative_player = obj_server.Network_players[? Player.connect_id]
								Authoritative_player.Team = obj_menu.Teams[? Section.team]
								Authoritative_player.spectating = false
								Authoritative_player.image_blend = obj_menu.color_array[Authoritative_player.player_color]
								ds_list_add(Team.Players, Authoritative_player)
							}
						}
					}
		        }
		    }
			#endregion
	}
}
#endregion
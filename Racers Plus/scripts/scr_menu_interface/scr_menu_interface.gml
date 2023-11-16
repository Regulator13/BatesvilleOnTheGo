function menu_declare_interface_functions(){
	version = "0.1.0"

	randomize()
	
	//Models 0 = Red Car, 1 = Police Car, 2 = Sport's car, 3 = Taxi 4 = Ambulance
	//5 = Pickup, 6 = Van, 7 = Orange Car, 8 = Semi
	model_sprites = [spr_car, spr_police, spr_racecar, spr_taxi, spr_ambulance, spr_truck, spr_van,
			spr_widecar, spr_semi]

	//universal colour array
	color_array[0] = #ffffff;
	color_array[1] = #6699ff;
	color_array[2] = #ff0000;
	color_array[3] = #33cc33;
	color_array[4] = #cc0099;
	color_array[5] = #00ffcc;
	color_array[6] = #ff9900;
	color_array[7] = #9900cc;
	color_array[8] = #66ff66;
	color_array[9] = #ffff00;

	menu_init = function(state) {
		switch state {
			case STATE_MAIN:
				#region Initiate main menu
			    //reset selected
				selected_button_index = 0

				//display variables
				var hb = 176+64//height buffer for the header bar
				var yb = 0//y buffer incremented by one after each button
				var s = 48//spacing between buttons

				// Create buttons
				menu_create_button(room_width/2 - 154/2, hb+s*yb++ + 16, function(){
						menu_state_switch(obj_menu.state, STATE_ONLINE)
						}, "online")
				menu_create_button(room_width/2 - 154/2, room_height-64 - 16, "quit", "quit")
				#endregion
				break
			case STATE_ONLINE:
				#region Initiate online menu
			    //reset selected
				selected_button_index = 1 // start on host button

				// set room width and height manually, in case of changing from game
				var rw = 640
				var rh = 480

				// setup online menu
				menu_create_button(96, rh - 32, "back", "back")
				// Host
				menu_create_button(rw - 96, rh - 96, function(){
						with obj_hybrid_online event_user(1)
						}, "host")
    
				// create online object to handle everything
				instance_create_layer(0, 0, "lay_instances", obj_hybrid_online)
				#endregion
				break
			case STATE_LOBBY:
				#region Initiate lobby menu
				global.level = 0
				
				obj_menu.selected_button_index = 0
	
				menu_create_button(96 - 154/2, room_height - 48, "back", "back")
				#endregion
				break
			case STATE_GAMECONFIG:
				#region Initiate online menu
			    
				#endregion
				break
			case STATE_SCORE:
				#region Score
				selected_button_index = 0
	
				menu_create_button(96 - 154/2, room_height-48, "quit", "quit")
				#endregion
				break
		}
	}
	
	draw_menu = function(state) {
		switch state {
			case STATE_MAIN:
			    break
			case STATE_LOBBY:
				break
			case STATE_SCORE:
				var dx = 128
				var dy = 64
				var di = 0
				var s = 32
		
				draw_set_halign(fa_left)
				draw_set_valign(fa_top)
		
				var _size = ds_list_size(Teams)
				for (var i = 0; i < _size; i++){
					var Team = Teams[| i]
					// Draw team
					draw_set_color(obj_menu.color_array[Team.team_color])
					draw_rectangle(dx, dy + di*s + 1, room_width - dx, dy + di*s + s - 2, true)
					if Team.team == 0 {
						//draw_text(dx, dy + di*s, "Mountain Man")
					}
					else {
						draw_text(dx, dy + di*s, "Team " + string(Team.team))
					}
					draw_text(dx + dx*2, dy + di*s, "Score: " + string(Team.team_score))
					draw_set_color(c_white)
					di++
			
					// Draw team players
					var team_players = ds_list_size(Team.Players)
					if team_players > 0 {
						draw_rectangle(dx, dy + di*s + 1, room_width - dx, dy + (di + team_players)*s - 2, true)
						for (var j = 0; j < team_players; j++){
							var Player = Team.Players[| j]
							draw_text(dx, dy + di*s, Player.player_name)
							if Player.ready_to_start{
								draw_text(dx + dx, dy + di*s, "Ready!")
							}
							di++
						}
					}
				}
				break
		}
	}
}
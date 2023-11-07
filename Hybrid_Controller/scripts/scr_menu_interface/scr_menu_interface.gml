function menu_declare_interface_functions(){
	version = "0.1.0"
	
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

				#endregion
				break
			case STATE_ONLINE:
				#region Initiate online menu
				
				#endregion
				break
			case STATE_LOBBY:
				#region Initiate lobby menu
				
				#endregion
				break
			case STATE_GAMECONFIG:
				#region Initiate online menu
			    
				#endregion
				break
			case STATE_SCORE:
				#region Score

				#endregion
				break
		}
	}
	
	draw_menu = function(state) {
		switch state {
			case STATE_MAIN:
				#region Initiate main menu

				#endregion
				break
			case STATE_ONLINE:
				#region Initiate online menu
				
				#endregion
				break
			case STATE_LOBBY:
				#region Initiate lobby menu

				#endregion
				break
			case STATE_GAMECONFIG:
				#region Initiate online menu
			    
				#endregion
				break
			case STATE_SCORE:
				#region Score

				#endregion
				break
		}
	}
}
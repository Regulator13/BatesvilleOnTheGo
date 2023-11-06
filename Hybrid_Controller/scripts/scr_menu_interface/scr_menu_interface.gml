function menu_declare_interface_functions(){
	version = "0.1.0"

	menu_init = function(state) {
		switch state {
			case STATE_MAIN:
				#region Initiate main menu

				#endregion
				break
			case STATE_ONLINE:
				#region Initiate online menu
				// create online object to handle everything
				instance_create_layer(0, 0, "lay_instances", obj_online)
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
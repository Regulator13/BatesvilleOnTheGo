function game_declare_interface_functions(){
	#region Menu
	state_switch = function(from, to){
		if to == STATE_LOBBY{
		}
		else if from == STATE_LOBBY{
			instance_destroy(obj_lobby)
		}
	}
	#endregion
	
	#region Networking
	server_reliable_game = function(msg_id, buffer, Connected_client) {
		with obj_server {
			
		}
	}
	
	/// @description Read the details of a game state sent over reliable UDP
	read_state = function(buffer){
		switch obj_menu.state{
			case STATE_LOBBY:
				
				break
		}
		
		#region Common
		
		#endregion
	}
	#endregion
}
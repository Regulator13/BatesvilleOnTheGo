/// @description Persistent container for game
// Overarching object for the game component

// Created when entering the lobby
// Destroyed when not in lobby, game config, or score screen

#region Networking
// List of all interactables
global.next_interactable_id = 0
global.Interactables = ds_list_create()
#endregion

event_inherited()

// Functions
game_declare_functions()
game_declare_interface_functions()

#region Interactions
request_interaction = function(interaction){
	switch interaction{
		case GAME_JOIN:
			var connect_id = argument[1]
			if global.online{
				request_interaction_u8(obj_client.connect_id, interactable_id, interaction, connect_id)
			}
			break
		case GAME_UPDATE_PLAYER_TEAM:
		case GAME_UPDATE_PLAYER_COLOR:
		case GAME_UPDATE_PLAYER_MODEL:
			var connect_id = argument[1]
			var value = argument[2]
			if global.online{
				request_interaction_u8_u8(obj_client.connect_id, interactable_id, interaction, connect_id, value)
			}
			break
		case GAME_DRIVE_UPDATE:
			var connect_id = argument[1]
			var throttle = argument[2]
			var steer = argurment[3]*100
			if global.online{
				// s8 would also work
				request_interaction_u8_s16_s16(obj_client.connect_id, interactable_id,
						interaction, connect_id, throttle, steer)
			}
		case GAME_PICKUP:
			var connect_id = argument[1]
			var value = argument[2]
			if global.online{
				request_interaction_u8_u8(obj_client.connect_id, interactable_id, interaction, connect_id, value)
			}	
	}
}
#endregion
#endregion

#region Lobby log
log_message = function(entry) {
	file_text_write_string(global.lobby_log, string("obj_campaign {0}", entry))
	file_text_writeln(global.lobby_log)
}
#endregion
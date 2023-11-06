/// @description Lobby functions
// Lobby manages player selections
// Created in menu_init_lobby after menu buttons called by menu_state_switch()

// Set interactable id
event_inherited()

lobby_declare_functions()
lobby_declare_interface_functions()


#region Interactions
request_interaction = function(interaction){
	switch interaction{
		case LOBBY_INITIALIZE:
			var seed = argument[1]
			if global.online{
				request_interaction_u8(obj_client.connect_id, interactable_id, interaction, seed)
			}
			break
		case LOBBY_JOIN:
			// Join an entirely new player to the lobby
			if global.online{
				// TODO: u8 is not needed
				request_interaction_u8(obj_client.connect_id, interactable_id, interaction, obj_client.connect_id)
			}
			break
		case LOBBY_MISSION_CHANGE:
			var mission_index = argument[1]
			if global.online{
				request_interaction_u8(obj_client.connect_id, interactable_id, interaction, mission_index)
			}
			break
		case LOBBY_ROLE_CHANGE:
			var slot_id = argument[1]
			if global.online{
				request_interaction_u8_u8(obj_client.connect_id, interactable_id, interaction, obj_client.connect_id, slot_id)
			}
			break
		case LOBBY_UPDATE_PLAYER:
			var ready_to_start = argument[1]
			var player_name = argument[2]
			if global.online{
				request_interaction_u8_u8_string(obj_client.connect_id, interactable_id, interaction, obj_client.connect_id, ready_to_start, player_name)
			}
			break
	}
}
#endregion

#region Lobby log
global.lobby_log = file_text_open_write("lobby.log")

log_message = function(entry) {
	file_text_write_string(global.lobby_log, string("obj_lobby {0}", entry))
	file_text_writeln(global.lobby_log)
}
#endregion
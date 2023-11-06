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

Available_maps = load_maps()

// Selected mission
mission = noone
// Generated missions
missions = []

// max 255
next_group_id = 0
Groups = ds_list_create()
Group_ids = ds_map_create()

lobby_slot_map = ds_map_create()

#region Interactions
perform_interaction = function(interaction){
	switch interaction{
		case GAME_JOIN:
			var connect_id = argument[1]
			
			// obj_player instances
			var Player = obj_server.Connected_clients[? connect_id].Player
			Player.Group = Groups[| 0]
			Player.slot_index = 0
			break
		case GAME_GROUP_ADD:
			var store_units_index = argument[1]
			var Unit = add_unit(Available_units[store_units[store_units_index]])
			with obj_lobby{
				perform_interaction(LOBBY_SECTION_ADD, obj_campaign.create_section(Unit))
			}
			break
	}
}

#region Networking
#region Read interactions
read_interaction = function(interaction, buff){
	switch interaction{
		case GAME_JOIN:
			var connect_id = buffer_read(buff, buffer_u8)
			perform_interaction(interaction, connect_id)
			break
		case GAME_GROUP_ADD:
			var store_units_index = buffer_read(buff, buffer_u8)
			perform_interaction(interaction, store_units_index)
			break
	}
}
#endregion
#endregion
#endregion
#endregion

#region Lobby log
log_message = function(entry) {
	file_text_write_string(global.lobby_log, string("obj_campaign {0}", entry))
	file_text_writeln(global.lobby_log)
}
#endregion
/// @description Persistent container for game
// Overarching object for the game component

// Created when entering the lobby
// Destroyed when not in lobby, game config, or score screen

#region Networking
// List of all interactables
global.next_interactable_id = 0
global.Interactables = ds_list_create()
#endregion

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

#region actions

#endregion

#region Lobby log
log_message = function(entry) {
	file_text_write_string(global.lobby_log, string("obj_campaign {0}", entry))
	file_text_writeln(global.lobby_log)
}
#endregion
/// @description Lobby menu
//this object will store the player configurations in the lobby for display only
//it will store things like which players are in what spawns,
//and configurations for each spawn via a section object
//this will allow for easier switching between maps while keeping previous spawn settings

//neutrals
global.section_color[0] = c_green

//load available maps
Available_maps = load_maps()
//server side map selector
In_map = noone
//the current map for the lobby
Map = noone

//drawing parameters, stored here so they can be accessed when creating the input boxes
section_draw_start_x = 32
section_draw_start_y = 32
section_draw_width = 500
section_draw_height = 26

//List of sections available for players
//one default section for spectators, and other sections for each spawn
Sections = ds_list_create()
ds_list_add(Sections, scr_create_section(DEFAULT_SECTION, 0))

//distance from edge to do drawing like text within a surronding rectangle
edge = 1

//section header parameter x positions
team_draw_start = 320
color_draw_start = 480

if global.have_server{
	//keep separate the authorotative sections
	Network_sections = ds_list_create()
	ds_list_add(Network_sections, scr_create_section(NETWORK_SECTION, 0))
	network_map_index = 0
	//update the server to send over the correct info for the starting map
	scr_server_update_map(Available_maps[network_map_index])
	
	// Read all players if this lobby is restarting after a game
	var _count = ds_list_size(obj_server.active_connect_ids)
	for (var i=0; i<_count; i++) {
		// obj_network_player instances
		var Authoritative_player = obj_server.Network_players[? obj_server.active_connect_ids[| i]]
		scr_add_to_sections(Authoritative_player, Authoritative_player.team)
	}
	
	// Start with the first map instead of waiting for
	// obj_client to set it after the first scr_read_lobby to avoid
	// race conditions with starting too fast
	scr_lobby_update_map(Available_maps[network_map_index])
}
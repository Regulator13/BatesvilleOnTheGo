/// @function scr_lobby_update_map(Map)
/// @description updates the lobby map and all sections to match according to the given map instance
/// @param Map | obj_map instance
//  Returns none
function scr_lobby_update_map(Map){
	//a new map has been selected, update the lobby sections
	//set any players in sections that no longer exists on this map to the default section
	var new_section_amount = Map.spawn_amount + 1
	//add any new section
	for (var i = 0; i < new_section_amount; i++){
		var Section = obj_lobby.Sections[| i]
		if is_undefined(Section){
			Section = scr_create_section(SPAWN_SECTION, i)
			ds_list_add(obj_lobby.Sections, Section)
		}
		//update team options if not spectators
		if Section.section_type == SPAWN_SECTION{
			for (var j=0; j<Map.spawn_amount; j++){
				//Section.Team_box.field_options[j] = j + 1
			}
		}
	}
	//remove any section no longer available
	//since removing elements from the list, update list size each loop iteration
	for (var i = new_section_amount; i < ds_list_size(obj_lobby.Sections); i++){
		var Section = obj_lobby.Sections[| i]
		instance_destroy(Section)
		ds_list_delete(obj_lobby.Sections, i)
		//reduce counter since removing elements from the list
		i--
	}
	obj_lobby.Map = Map
}

/// @function scr_server_update_map(Map)
/// @description updates the lobby map and all sections to match according to the given map instance
/// @param Map | obj_map instance
//  Returns none
function scr_server_update_map(Map){
	//a new map has been selected, update the lobby sections
	//set any players in sections that no longer exists on this map to the default section
	var new_section_amount = Map.spawn_amount + 1
	//add any new section
	for (var i = 0; i < new_section_amount; i++){
		var Section = obj_lobby.Network_sections[| i]
		if is_undefined(Section){
			//section did not exist before, add now
			Section = scr_create_section(NETWORK_SECTION, i)
			ds_list_add(obj_lobby.Network_sections, Section)
		}
	}
	
	var Default_section = obj_lobby.Network_sections[| 0]
	//remove any section no longer available
	//since removing elements from the list, update list size each loop iteration
	for (var i = new_section_amount; i < ds_list_size(obj_lobby.Network_sections); i++){
		var Section = obj_lobby.Network_sections[| i]
		
		//move all players in obsolete section to the default section
		var _length = ds_list_size(Section.Players)
		for (var j=0; j<_length; j++){
			//get the obj_network_player instance
			var Player = Section.Players[| j]
			scr_move_sections(Player, Default_section, ds_list_size(Default_section.Players), -1)
		}
		
		instance_destroy(Section)
		ds_list_delete(obj_lobby.Network_sections, i)
		//reduce counter since removing elements from the list
		i--
	}
	//obj_lobby.Network_map = Map
}

/// @function scr_move_sections(Player, New_section, new_index, new_y)
/// @description Update the players section in the lobby
/// @param Player | Player to update
/// @param New_section | obj_lobby_section instance
/// @param new_index | position to insert player into new section
/// @parm new_y | drawing y for any player changeable attributes
//  Returns null
function scr_move_sections(Player, New_section, new_index, new_y){
	if Player.Section == New_section and ds_list_find_index(Player.Section.Players, Player) == new_index{
		//player is already in the right spot
	}
	else{
		//remove player from previous section
		if instance_exists(Player.Section){
			var prev_index = ds_list_find_index(Player.Section.Players, Player)
			if prev_index != -1 ds_list_delete(Player.Section.Players, prev_index)
		}
		ds_list_insert(New_section.Players, new_index, Player)
		Player.Section = New_section
		Player.team = New_section.team
	}
	//update the y positions for the player's input boxes
	if New_section.section_type != NETWORK_SECTION{
		Player.Name_box.y = new_y
		Player.Ready_box.y = new_y
		Player.Color_box.y = new_y
	}
}

function scr_update_lobby_player(connect_id, player_name, ready_to_start, player_color){
	var Player = obj_client.Network_players[? connect_id]
	if is_undefined(Player){
		//add network player
		Player = instance_create_layer(0, 0, LAY, obj_player)
		Player.connect_id = connect_id
		if connect_id == obj_client.connect_id{
			Player.local = true
		}
		if global.have_server{
			var Network_player = obj_server.Network_players[? connect_id]
			Network_player.Player = Player
		}
		Player.Name_box = scr_create_text_box(obj_lobby.section_draw_start_x + obj_lobby.edge, 0, Player, "", player_name, "client-send-name", Player.local, 15)
		Player.Ready_box = scr_create_checkbox(obj_lobby.section_draw_start_x + obj_lobby.section_draw_width - 24 - obj_lobby.edge, 0, Player, "client-send-ready", Player.local, "Ready: ")
		Player.Color_box = scr_create_dropdown(obj_lobby.section_draw_start_x + 160, 0, Player, "color", Player.connect_id, "client-send-player-color", true, 24, 24)
		if ds_map_add(obj_client.Network_players, connect_id, Player) {
			// ds_map_add returns true if the key does not already exist
			// If the key does exist, then this lobby was created after the score menu
			// and the client already has this as an active connect_id
			ds_list_add(obj_client.active_connect_ids, connect_id)
		}
		else{
			ds_map_replace(obj_client.Network_players, connect_id, Player)
		}
	}
	Player.player_name = player_name
	Player.ready_to_start = ready_to_start
	// Instance exists checks are neccessary for when the lobby is
	// rentered after a game
	if not instance_exists(Player.Name_box) Player.Name_box = scr_create_text_box(obj_lobby.section_draw_start_x + obj_lobby.edge, 0, Player, "", player_name, "client-send-name", Player.local, 15)
	if not instance_exists(Player.Ready_box) Player.Ready_box = scr_create_checkbox(obj_lobby.section_draw_start_x + obj_lobby.section_draw_width - 24 - obj_lobby.edge, 0, Player, "client-send-ready", Player.local, "Ready: ")
	if not instance_exists(Player.Color_box) Player.Color_box = scr_create_dropdown(obj_lobby.section_draw_start_x + 160, 0, Player, "color", Player.connect_id, "client-send-player-color", true, 24, 24)
	Player.Name_box.text = player_name
	Player.Ready_box.field = ready_to_start
	Player.Color_box.field = player_color
	
	if connect_id == obj_client.connect_id{
		//update name for saving
		obj_client.player_name = player_name
	}
	return Player
}

function scr_add_to_sections(Authoritative_player, section){
	if is_undefined(section) {
		//check first to see if any spawn is empty
		for (var i = 1; i < ds_list_size(obj_lobby.Network_sections); i++){
			var Section = obj_lobby.Network_sections[| i]
			if ds_list_size(Section.Players) == 0{
				ds_list_add(Section.Players, Authoritative_player)
				Authoritative_player.Section = Section
				Authoritative_player.team = i
				return Section
			}
		}
		//else add to default section
		var Default_section = obj_lobby.Network_sections[| 0]
		ds_list_add(Default_section.Players, Authoritative_player)
		Authoritative_player.Section = Default_section
		Authoritative_player.team = 0
		return Default_section
	}
	else {
		var Section = obj_lobby.Network_sections[| section]
		ds_list_add(Section.Players, Authoritative_player)
		Authoritative_player.Section = Section
		Authoritative_player.team = section
		return Section
	}
}
////TODO
function controller_read_lobby(buff){
	var Player = obj_client.Player
	if not instance_exists(Player){
		show_debug_message("controller_read_lobby player instance does not exist")
		//add network player
		Player = instance_create_layer(0, 0, LAY, obj_player)
		Player.Parent.connect_id = obj_client.connect_id
		Player.local = true
		obj_client.Player = Player
	}
	Player.team = buffer_read(buff, buffer_u8)
	Player.player_color = buffer_read(buff, buffer_u8)
	Player.model = buffer_read(buff, buffer_u8)
	Player.player_name = buffer_read(buff, buffer_string)
	Player.ready_to_start = buffer_read(buff, buffer_bool)
}

////TODO
function scr_read_lobby(buffer){
	//server sends over all sections and players in the sections each step
	
	//keep track of which players are updated to remove players no longer in game
	var remove_connect_ids = ds_list_create()
	ds_list_copy(remove_connect_ids, active_connect_ids)
							
	//get map index
	var map_index = buffer_read(buffer, buffer_u8)
	var Map = obj_lobby.Available_maps[map_index]
	//update the map first
	//this will create the proper sections for the next part
	if Map != obj_lobby.Map{
		//this map is different that what the client has selected
		scr_lobby_update_map(Map)
	}
							
	//update the drawing y positions
	var _y = obj_lobby.section_draw_start_y
	//iterate through each section, which already exists from scr_update_lobby_map
	var section_amount = buffer_read(buffer, buffer_u8)
	for (var i=1; i<section_amount; i++){
		//update section info
		var Section = obj_lobby.Sections[| i]
		var team = buffer_read(buffer, buffer_u8)
		var spawn_color = buffer_read(buffer, buffer_u8)
		//Section.Team_box.field = team
		Section.Color_box.field = spawn_color
		//update section position
		//Section.Team_box.y = _y
		Section.Color_box.y = _y
		_y += obj_lobby.section_draw_height
								
		//update all players in this section
		var players_in_section = buffer_read(buffer, buffer_u8)
		for (var j=0; j<players_in_section; j++){
			var conn_id = buffer_read(buffer, buffer_u8)
			var player_name = buffer_read(buffer, buffer_string)
			var ready_to_start = buffer_read(buffer, buffer_bool)
			var player_color = buffer_read(buffer, buffer_u8)
									
			var Player = scr_update_lobby_player(conn_id, player_name, ready_to_start, player_color)
			scr_move_sections(Player, Section, j, _y)
			//player is still in game
			ds_list_delete(remove_connect_ids, ds_list_find_index(remove_connect_ids, conn_id))
			_y += obj_lobby.section_draw_height
		}
		//update button position
		Section.Join_box.y = _y
		_y += obj_lobby.section_draw_height
	}
	//default section
	i = 0
	//update section info
	var Section = obj_lobby.Sections[| i]
	_y += obj_lobby.section_draw_height
								
	//update all players in this section
	var players_in_section = buffer_read(buffer, buffer_u8)
	for (var j=0; j<players_in_section; j++){
		var conn_id = buffer_read(buffer, buffer_u8)
		var player_name = buffer_read(buffer, buffer_string)
		var ready_to_start = buffer_read(buffer, buffer_bool)
		var player_color = buffer_read(buffer, buffer_u8)
									
		var Player = scr_update_lobby_player(conn_id, player_name, ready_to_start, player_color)
		scr_move_sections(Player, Section, j, _y)
		//player is still in game
		ds_list_delete(remove_connect_ids, ds_list_find_index(remove_connect_ids, conn_id))
								
		_y += obj_lobby.section_draw_height
	}
	//update button position
	Section.Join_box.y = _y
	_y += obj_lobby.section_draw_height
							
	//remove any player not sent over by the server
	var _count = ds_list_size(remove_connect_ids)
	for (var i=0; i<_count; i++){
		var Player = obj_client.Network_players[? remove_connect_ids[| i]]
		instance_destroy(Player)
	}
	ds_list_destroy(remove_connect_ids)
}
function lobby_declare_functions(){
	state_switch = function(from, to){
		if to == STATE_LOBBY{
			// Lobby gets missions and sections from the game campaign object
			#region Missions
			// Set by obj_client upon recieving SERVER_LOGIN
			// Currently selected mission
			selected_mission = 0
		}
		if from == STATE_LOBBY{
			instance_destroy(Mission_box)
		}
		
		if from == STATE_ONLINE and to == STATE_LOBBY{
			
		}
		else if from == STATE_SCORE and to == STATE_LOBBY{
			// Reset start so it can be checked for again
			obj_server.start = false
			
			if global.have_server{
				
			}
		}
	}
	
	initialize_lobby = function(){
		#region Players
		for (var i=0; i<ds_list_size(obj_server.active_connect_ids); i++){
			lobby_create_player(obj_server.active_connect_ids[| i])
		}
		#endregion
		
		// array - stc_lobby_mission
		missions = obj_campaign.get_missions()

		// mission selector dropdown
		var ix = map_draw_start_x
		var iy = map_draw_start_y + map_draw_size + 48
		var field_options = []
		var _length = array_length(missions)
		for (var i=0; i<_length; i++){
			field_options[i] = missions[i].get_title()
		}
		Mission_box = menu_create_dropdown(ix, iy, "text", 0, field_options, function(field){
					obj_lobby.request_interaction(LOBBY_MISSION_CHANGE, field)
				}, true, 232, 24)

		#endregion

		#region Sections
		sections = obj_campaign.get_sections()
		#endregion
		
		// Add players not in a slot to default section
		for (var i=0; i<ds_list_size(obj_server.active_connect_ids); i++){
			var player = players[? obj_server.active_connect_ids[| i]]
			if player.slot == noone{
				// Join default section
				var slot_id = get_open_slot_id(0)
				// Since already in a perform interaction, do not need to go through networking again
				perform_interaction(LOBBY_SLOT_JOIN, player.connect_id, slot_id)
			}
		}
	}
	
	get_mission = function(){
		return missions[selected_mission]
	}
	
	get_sections = function(){
		return sections
	}
	
	get_players = function(){
		return players
	}
	
	get_open_slot_id = function(section_index){
		var section = sections[section_index]
		var slot = section.slots[0]
		while slot.player != noone{
			slot = slot.slots[0]
		}
		return slot.slot_id
	}
	
	draw_slot = function(slot, _x, _y){
		if slot.active{
			// Draw slots for each slot
			draw_set_color(c_gray)
			draw_rectangle(_x, _y, _x + section_draw_width, _y + section_draw_height, false)
			draw_set_color(c_white)
			draw_rectangle(_x, _y, _x + section_draw_width, _y + section_draw_height, true)
			
			// Draw ready status
			var player = slot.player
			if player != noone{
				draw_text(section_draw_width - 300, _y, "Connect ID: " + string(player.connect_id))
			}
	
			// Information about player is displayed in the pertinent input box instances
			_y += section_draw_height
	
			// Draw sub slots
			var slot_amount = array_length(slot.slots)
			for (var j=0; j<slot_amount; j++){
				var subslot = slot.slots[j]
				_y = draw_slot(subslot, _x, _y)
			}
		}
		return _y
	}
	
	select_slot = function(slot, _x, _y){
		if slot.active{
			// Check if selecting this slot
			var player = slot.player
			if player == noone{
				if point_in_rectangle(mouse_x, mouse_y, _x, _y, _x + section_draw_width, _y + section_draw_height){
					request_interaction(LOBBY_ROLE_CHANGE, slot.slot_id)
				}
			}
	
			// Information about player is displayed in the pertinent input box instances
			_y += section_draw_height
	
			// Draw sub slots
			var slot_amount = array_length(slot.slots)
			for (var j=0; j<slot_amount; j++){
				var subslot = slot.slots[j]
				_y = select_slot(subslot, _x, _y)
			}
		}
		return _y
	}
}
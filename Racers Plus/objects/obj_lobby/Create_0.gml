/// @description Lobby functions
// Lobby manages player selections
// Created in menu_init_lobby after menu buttons called by menu_state_switch()

// Set interactable id
event_inherited()

//drawing parameters, stored here so they can be accessed when creating the input boxes
section_draw_start_x = 32
section_draw_start_y = 32
section_draw_width = 512
section_draw_height = 26

//distance from edge to do drawing like text within a surronding rectangle
edge = 1

//section header parameter x positions
color_draw_start = 230

//minimap display
map_draw_size = 256
map_draw_start_x = room_width - 32 - map_draw_size
map_draw_start_y = 32

// Missions
selected_mission = 0
missions = []
Mission_box = noone

// Sections
sections = []

// Each stc_lobby_slot has a unique ID to reference
next_slot_id = 0
slots = ds_map_create()
players = ds_map_create()

lobby_declare_functions()
lobby_declare_interface_functions()


#region Interactions
perform_interaction = function(interaction){
	switch interaction{
		case LOBBY_INITIALIZE:
			var seed = argument[1]
			// Generate new mission and unit options
			obj_campaign.generate_new_lobby(seed)
			initialize_lobby()
			break
		case LOBBY_MISSION_CHANGE:
			var mission_index = argument[1]
			selected_mission = mission_index
			break
		case LOBBY_JOIN:
			// Join an entirely new player to the lobby
			var connect_id = argument[1]
			var player = lobby_create_player(connect_id)
			
				// Join default section
				var slot_id = get_open_slot_id(0)
				// Since already in a perform interaction, do not need to go through networking again
				perform_interaction(LOBBY_SLOT_JOIN, connect_id, slot_id)
			
			break
		case LOBBY_UPDATE_PLAYER:
			var connect_id = argument[1]
			var ready_to_start = argument[2]
			var player_name = argument[3]
			var player = players[? connect_id]
			player.ready_to_start = ready_to_start
			player.player_name = player_name
			break
		case LOBBY_SECTION_ADD:
			var new_section = argument[1]
			sections[array_length(sections)] = new_section
			break
		case LOBBY_SLOT_JOIN:
			var connect_id = argument[1]
			var slot_id = argument[2]
			
			var player = players[? connect_id]
			var slot = slots[? slot_id]
			
			slot.player = player
			player.slot = slot
			
			// Enable subslots
			if not slot.unique and array_length(slot.slots) == 0{
				// Duplicate slot as subslot
				slot.slots[0] = slot.copy()
			}
			for (var i=0; i<array_length(slot.slots); i++){
				slot.slots[i].active = true
			}
			
			break
		case LOBBY_ROLE_LEAVE:
			var slot_id = argument[1]
			var slot = slots[? slot_id]
			slot.player = noone
			// Disable subslots
			for (var i=0; i<array_length(slot.slots); i++){
				slot.slots[i].active = false
			}
			
			// Replace player with player in subslot if possible
			// May reenable sub slots
			for (var i=0; i<array_length(slot.slots); i++){
				var subslot = slot.slots[i]
				if subslot.player != noone{
					perform_interaction(LOBBY_SLOT_JOIN, subslot.player.connect_id, slot.slot_id)
					perform_interaction(LOBBY_ROLE_LEAVE, subslot.slot_id)
					break
				}
			}
			break
		case LOBBY_ROLE_CHANGE:
			var connect_id = argument[1]
			var slot_id = argument[2]
			
			var player = players[? connect_id]
			
			// Add player first to new slot and then remove from previous slot in case
			// they are trying to join their own subslot
			var old_slot = player.slot
			// Add player to new slot
			perform_interaction(LOBBY_SLOT_JOIN, connect_id, slot_id)
			
			// Remove player from previous slot
			perform_interaction(LOBBY_ROLE_LEAVE, old_slot.slot_id)
			
			break
	}
}

read_interaction = function(interaction, buff){
	switch interaction{
		case LOBBY_INITIALIZE:
			var seed = buffer_read(buff, buffer_u8)
			perform_interaction(interaction, seed)
			break
		case LOBBY_MISSION_CHANGE:
			// Join an entirely new player to the lobby
			var mission_index = buffer_read(buff, buffer_u8)
			perform_interaction(interaction, mission_index)
			break
		case LOBBY_JOIN:
			// Join an entirely new player to the lobby
			var connect_id = buffer_read(buff, buffer_u8)
			perform_interaction(interaction, connect_id)
			break
		case LOBBY_SECTION_ADD:
			break
		case LOBBY_ROLE_CHANGE:
			var connect_id = buffer_read(buff, buffer_u8)
			var slot_id = buffer_read(buff, buffer_u8)
			perform_interaction(interaction, connect_id, slot_id)
			break
		case LOBBY_UPDATE_PLAYER:
			var connect_id = buffer_read(buff, buffer_u8)
			var ready_to_start = buffer_read(buff, buffer_u8)
			var player_name = buffer_read(buff, buffer_string)
			perform_interaction(interaction, connect_id, ready_to_start, player_name)
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
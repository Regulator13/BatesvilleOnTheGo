function game_declare_interface_functions(){
	#region Menu
	state_switch = function(from, to){
		if to == STATE_LOBBY{
			// If the host, initialize the lobby
			var seed = 255
			obj_lobby.perform_action(ACT_LOBBY_INITIALIZE, seed)
		}
		else if from == STATE_LOBBY{
			// Get mission
			mission = obj_lobby.get_mission()
			
			// Translate lobby slot selections into group slot selections
			var sections = obj_lobby.get_sections()
			for (var i=0; i<array_length(sections); i++){
				var section = sections[i]
				
				var slot_amount = array_length(section.slots)
				for (var j=0; j<slot_amount; j++){
					var slot = section.slots[j]
					translate_slot(slot)
				}
			}
			ds_map_clear(lobby_slot_map)
			
			global.setup = mission.setup
			
			instance_destroy(obj_lobby)
		}
	}
	#endregion
	
	#region Lobby
	generate_new_lobby = function(seed){
		// Ensure random is consistent in case generating across clients
		random_set_seed(seed)
		
		// Create one mission
		var Map = Available_maps[0]
		var setup = irandom(Map.setups - 1)
		var level = 0
		missions[0] = new stc_lobby_mission(Map, setup, level)
		
		// Create groups
		var Group = instance_create_layer(0, 0, "lay_instances", obj_group,
				{
					title : "Detectives",
				})
		ds_list_add(Groups, Group)

	}
	
	get_missions = function(){
		return missions
	}
	
	get_sections = function(){
		var sections = []
		var section_index = 0
		// Add exisiting group sections
		for (var i=0; i<ds_list_size(obj_campaign.Groups); i++){
			var Group = obj_campaign.Groups[| i]
			
			sections[section_index++] = create_section(Group)
		}
		
		return sections
	}
	
	create_section = function(Group){
		var slots = []
		var slot_amount = ds_list_size(Group.Players)
		for (var j=0; j<slot_amount; j++){
			var Player = Group.Players[| j]
			slots[j] = lobby_create_slot([])
			
			// Place player if exists
			if instance_exists(Player){
				obj_lobby.perform_action(LOBBY_SLOT_JOIN, Player.Parent.connect_id, slots[j].slot_id)
			}
			
			// Map this lobby slot back to the group for future reference
			ds_map_add(lobby_slot_map, slots[j].slot_id, new stc_slot_map(Group.group_id, j))
		}
		// Add default slot
		slots[slot_amount] = lobby_create_slot([])
		return new stc_lobby_section(Group.title, slots)
	}
	
	translate_slot = function(slot){
		if slot.active{
			// Translate slot from lobby to game
			if slot.player != noone{
				// obj_player instances
				var Player = obj_hybrid_server.Connected_hybrid_clients[? slot.player.connect_id].Player
				
				// Remove player from previous slot
				with Player.Group{
					ds_list_delete(Player.Group.Players, ds_list_find_index(Player.Group.Players, Player))
				}
				
				// Use preiously populated map
				if ds_map_exists(lobby_slot_map, slot.slot_id){
					var group_id = lobby_slot_map[? slot.slot_id].group_id
					var slot_index = lobby_slot_map[? slot.slot_id].slot_index
					
					var Group = obj_campaign.Group_ids[? group_id]
				}
				
				//Player.slot_index = slot_index
				//Group.slots[slot_index].Player = Player
			}
			
			// Translate subslots
			var slot_amount = array_length(slot.slots)
			for (var j=0; j<slot_amount; j++){
				var subslot = slot.slots[j]
				translate_slot(subslot)
			}
		}
	}
	#endregion
	
	#region Networking
	server_reliable_game = function(msg_id, buffer, Connected_hybrid_client) {
		with obj_hybrid_server {
			
		}
	}
	
	/// @description Fills the buffer of state details to be sent via reliable UDP
	write_state = function(buffer){
		switch obj_menu.state{
			case STATE_LOBBY:
				// If host lobby is already initialized, will need to share
				
				// Missions
				var mission_amount = array_length(missions)
				buffer_write(buffer, buffer_u8, mission_amount)
				for (var j=0; j<mission_amount; j++){
					missions[j].write_to_buffer(buffer)
				}
				break
		}
		
		#region Common
		// Current players
		var player_amount = ds_list_size(obj_hybrid_server.client_connect_ids) - 1
		buffer_write(buffer, buffer_u8, player_amount)
		for (var j=0; j<player_amount; j++) {
			// obj_connected_hybrid_client instances
			var Connected_hybrid_client = ds_map_find_value(obj_hybrid_server.Connected_hybrid_clients, obj_hybrid_server.client_connect_ids[| j])
			buffer_write(buffer, buffer_u8, Connected_hybrid_client.connect_id)
			buffer_write(buffer, buffer_string, Connected_hybrid_client.Player.player_name)
			buffer_write(buffer, buffer_bool, Connected_hybrid_client.Player.ready_to_start)
		}
		
		// Groups
		var group_amount = ds_list_size(obj_campaign.Groups)
		buffer_write(buffer, buffer_u8, group_amount)
		for (var j=0; j<group_amount; j++){
			obj_campaign.Groups[| j].write_to_buffer(buffer)
		}
		
		// Current players' Groups
		var player_amount = ds_list_size(obj_hybrid_server.client_connect_ids) - 1
		buffer_write(buffer, buffer_u8, player_amount)
		for (var j=0; j<player_amount; j++) {
			// obj_player instances
			var Player = obj_hybrid_server.Connected_hybrid_clients[? obj_hybrid_server.client_connect_ids[| j]].Player
			buffer_write(buffer, buffer_u8, Player.Parent.connect_id)
			buffer_write(buffer, buffer_u8, Player.Group.group_id)
		}
		#endregion
	}
	/// @description Read the details of a game state sent over reliable UDP
	read_state = function(buffer){
		
	}
	/// @description Fills the buffer of state updates to be sent via regular UDP
	write_state_update = function(buffer) {
		// Regular UDP updates which don't require a synced action
		switch obj_menu.state{
			case STATE_GAMECONFIG:
				// Client specific status
				var _length = ds_list_size(obj_hybrid_server.active_connect_ids)
				buffer_write(buffer, buffer_u8, _length)
				for (var i=0; i<_length; i++){
					// obj_connected_hybrid_clientinstances
					var Connected_hybrid_client = obj_hybrid_server.Connected_hybrid_clients[? obj_hybrid_server.active_connect_ids[| i]]
					buffer_write(buffer, buffer_u8, Connected_hybrid_client.connect_id)
					buffer_write(buffer, buffer_bool, Connected_hybrid_client.Player.ready_to_start)
				}
				break
			case STATE_GAME:
				// Write mob update
				var mob_amount = ds_list_size(global.Mobs)
				for (var i=0; i<mob_amount; i++){
					var Mob = global.Mobs[| i]
					Mob.write_to_buffer(buffer)
				}
				break
			case STATE_SCORE:
				break
		}
	}
	/// @description Read update to a game state sent over regular UDP
	read_state_update = function(buffer){
		switch obj_menu.state {
			case STATE_GAMECONFIG:
				if obj_menu.state == STATE_GAMECONFIG {

				}
				break
			case STATE_GAME:
				if obj_menu.state == STATE_GAME {
					if not global.have_hybrid_server{
						// Read common data
						var mob_amount = ds_list_size(global.Mobs)
						for (var i=0; i<mob_amount; i++){
							var Mob = global.Mobs[| i]
							Mob.read_from_buffer(buffer)
						}
					}
				}
				break
			case STATE_SCORE:
				break
		}
	}
	#endregion
}
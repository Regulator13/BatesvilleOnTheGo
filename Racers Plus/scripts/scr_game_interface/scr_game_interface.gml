function game_declare_interface_functions(){
	#region Menu
	state_switch = function(from, to){
		if to == STATE_LOBBY{
			// If the host, initialize the lobby
			if not global.online{
				var seed = 255
				obj_lobby.request_interaction(LOBBY_INITIALIZE, seed)
			}
			else if global.have_server{
				// If hosting, need to wait till connection is complete,
				// so request is made the first time in obj_client
				if from == STATE_SCORE{
					var seed = 255
					obj_lobby.request_interaction(LOBBY_INITIALIZE, seed)
				}
			}
		}
		else if from == STATE_LOBBY{
			// Get mission
			mission = obj_lobby.get_mission()
			
			// Translate lobby role selections into unit role selections
			var sections = obj_lobby.get_sections()
			for (var i=0; i<array_length(sections); i++){
				var section = sections[i]
				
				var role_amount = array_length(section.roles)
				for (var j=0; j<role_amount; j++){
					var role = section.roles[j]
					translate_role(role)
				}
			}
			ds_map_clear(lobby_role_map)
			
			// Update player names
			var players = obj_lobby.get_players()
			for (var i=0; i<array_length(players); i++){
				var player = players[i]
				var Network_player = obj_client.Network_players[? player.connect_id]
				Network_player.player_name = player.player_name
			}
			
			global.setup = mission.setup
			
			instance_destroy(Unit_box)
			instance_destroy(Unit_purchase_box)
			
			instance_destroy(obj_lobby)
		}
	}
	#endregion
	
	#region Lobby
	generate_new_lobby = function(seed){
		// Ensure random is consistent in case generating across clients
		random_set_seed(seed)
		
		// Create up to five missions
		for (var i=0; i<5; i++){
			var Map = Available_maps[irandom(array_length(Available_maps) - 1)]
			var setup = irandom(Map.setups - 1)
			var level = 0
			missions[i] = new stc_lobby_mission(Map, setup, level)
		}
	
		// Populate store with available units
		for (var i=0; i<5; i++){
			// Do not include default soldier
			store_units[i] = irandom_range(1, array_length(Available_units) - 1)
		}
		
		// Unit store
		var field_options = []
		var _length = array_length(obj_campaign.store_units)
		for (var i=0; i<_length; i++){
			field_options[i] = obj_campaign.Available_units[obj_campaign.store_units[i]].title
		}
		Unit_box = menu_create_dropdown(0, room_height - 128, "text", 0, field_options, function(field){}, true, 232, 24)


		Unit_purchase_box = menu_create_button(room_width/2, room_height - 96, function(){
					obj_campaign.request_interaction(GAME_UNIT_ADD, obj_campaign.Unit_box.field)
				}, "purchase")
	}
	
	get_missions = function(){
		return missions
	}
	
	get_sections = function(){
		var sections = []
		var section_index = 0
		// Default soldier section
		sections[section_index++] = new stc_lobby_section("Soldiers", [lobby_create_role("Soldier", [], true, false)])
		
		// Add exisiting unit sections
		for (var i=0; i<ds_list_size(obj_campaign.Units); i++){
			var Unit = obj_campaign.Units[| i]
			
			sections[section_index++] = create_section(Unit)
		}
		
		return sections
	}
	
	create_section = function(Unit){
		var roles = []
		var role_amount = array_length(Unit.Roles)
		for (var j=0; j<role_amount; j++){
			var Role = Unit.Roles[j]
			roles[j] = lobby_create_role(Role.title, [])
			
			// Place player if exists
			if instance_exists(Role.Player){
				obj_lobby.perform_interaction(LOBBY_ROLE_JOIN, Role.Player.Parent.connect_id, roles[j].role_id)
			}
			
			// Map this lobby role back to the unit for future reference
			ds_map_add(lobby_role_map, roles[j].role_id, new stc_role_map(Unit.unit_id, j))
		}
		return new stc_lobby_section(Unit.title, roles)
	}
	
	translate_role = function(role){
		if role.active{
			// Translate role
			if role.player != noone{
				// obj_player instances
				var Player = obj_client.Network_players[? role.player.connect_id].Player
				
				// Remove player from previous role
				with Player.Unit{
					Roles[Player.role_index].Player = noone
				}
				
				// Use preiously populated map
				if ds_map_exists(lobby_role_map, role.role_id){
					var unit_id = lobby_role_map[? role.role_id].unit_id
					var role_index = lobby_role_map[? role.role_id].role_index
					
					var Unit = obj_campaign.Unit_ids[? unit_id]
				}
				else{
					// This must be a soldier since not tied to a unit
					var Unit = Player.Soldier
					role_index = 0
				}
				
				Player.Unit = Unit
				Player.role_index = role_index
				Unit.Roles[role_index].Player = Player
			}
			
			// Translate subroles
			var role_amount = array_length(role.roles)
			for (var j=0; j<role_amount; j++){
				var subrole = role.roles[j]
				translate_role(subrole)
			}
		}
	}
	#endregion
	
	#region Networking
	server_reliable_game = function(msg_id, buffer, Connected_client) {
		with obj_server {
			
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
				
				// Store
				var store_amount = array_length(store_units)
				buffer_write(buffer, buffer_u8, store_amount)
				for (var i=0; i<store_amount; i++){
					buffer_write(buffer, buffer_u8, store_units[i])
				}
				break
		}
		
		#region Common
		// Current players
		var player_amount = ds_list_size(obj_server.client_connect_ids) - 1
		buffer_write(buffer, buffer_u8, player_amount)
		for (var j=0; j<player_amount; j++) {
			if j != i{
				// obj_connected_client instances
				var Connected_client = ds_map_find_value(obj_server.Connected_clients, obj_server.client_connect_ids[| j])
				buffer_write(buffer, buffer_u8, Connected_client.connect_id)
				buffer_write(buffer, buffer_string, Connected_client.Player.player_name)
				buffer_write(buffer, buffer_bool, Connected_client.Player.ready_to_start)
			}
		}
									
		// Soldiers
		var unit_amount = ds_list_size(obj_campaign.Soldiers)
		buffer_write(buffer, buffer_u8, unit_amount)
		for (var j=0; j<unit_amount; j++){
				obj_campaign.Soldiers[| j].write_to_buffer(buffer)
		}
		// Units
		var unit_amount = ds_list_size(obj_campaign.Units)
		buffer_write(buffer, buffer_u8, unit_amount)
		for (var j=0; j<unit_amount; j++){
				obj_campaign.Units[| j].write_to_buffer(buffer)
		}
							
		// Current players' Units
		var player_amount = ds_list_size(obj_server.client_connect_ids) - 1
		buffer_write(buffer, buffer_u8, player_amount)
		for (var j=0; j<player_amount; j++) {
			if j != i{
				// obj_player instances
				var Player = obj_client.Network_players[? obj_server.client_connect_ids[| j]].Player
				buffer_write(buffer, buffer_u8, Player.Parent.connect_id)
				buffer_write(buffer, buffer_u8, Player.Unit.unit_id)
				buffer_write(buffer, buffer_u8, Player.role_index)
				var soldier_index = ds_list_find_index(obj_campaign.Soldiers, Player.Soldier)
				buffer_write(buffer, buffer_u8, soldier_index)
			}
		}
		#endregion
	}
	/// @description Read the details of a game state sent over reliable UDP
	read_state = function(buffer){
		switch obj_menu.state{
			case STATE_LOBBY:
				// Missions
				var mission_amount = buffer_read(buffer, buffer_u8)
				for (var i=0; i<mission_amount; i++){
					missions[i] = stc_lobby_mission_read_from_buffer(buffer)
				}
				
				// Store
				var store_amount = buffer_read(buffer, buffer_u8)
				for (var i=0; i<store_amount; i++){
					store_units[i] = buffer_read(buffer, buffer_u8)
				}
				
				// Store will only be populated if lobby has already be initialized
				if store_amount > 0{
					// Unit store
					var field_options = []
					var _length = array_length(store_units)
					for (var i=0; i<_length; i++){
						field_options[i] = Available_units[store_units[i]].title
					}
					Unit_box = menu_create_dropdown(0, room_height - 128, "text", 0, field_options, function(field){}, true, 232, 24)


					Unit_purchase_box = menu_create_button(room_width/2, room_height - 96, function(){
							obj_campaign.request_interaction(GAME_UNIT_ADD, obj_campaign.Unit_box.field)
							}, "purchase")
				}
				break
		}
		
		#region Common
		// Current players
		var player_amount = buffer_read(buffer, buffer_u8)
		for (var i=0; i<player_amount; i++) {
			//get the network player
			var _connect_id = buffer_read(buffer, buffer_u8)
			var _player_name = buffer_read(buffer, buffer_string)
			var _ready = buffer_read(buffer, buffer_bool)
			update_player(_connect_id, _player_name, _ready)
		}
		var unit_amount = buffer_read(buffer, buffer_u8)
		for (var i=0; i<unit_amount; i++){
			obj_campaign.read_soldier(buffer)							
		}
		var unit_amount = buffer_read(buffer, buffer_u8)
		for (var i=0; i<unit_amount; i++){
			obj_campaign.read_unit(buffer)
		}
		// Current players
		var player_amount = buffer_read(buffer, buffer_u8)
		for (var i=0; i<player_amount; i++) {
			//get the network player
			var _connect_id = buffer_read(buffer, buffer_u8)
			var unit_id = buffer_read(buffer, buffer_u8)
			var role_index = buffer_read(buffer, buffer_u8)
			var soldier_index = buffer_read(buffer, buffer_u8)
			
			// obj_player instances
			var Player = obj_client.Network_players[? _connect_id].Player
			Player.Unit = obj_campaign.Unit_ids[? unit_id]
			Player.role_index = role_index
			Player.Soldier = obj_campaign.Soldiers[| soldier_index]
		}
		#endregion
	}
	/// @description Fills the buffer of state updates to be sent via regular UDP
	write_state_update = function(buffer) {
		// Regular UDP updates which don't require a synced interaction
		switch obj_menu.state{
			case STATE_GAMECONFIG:
				// Client specific status
				var _length = ds_list_size(obj_server.active_connect_ids)
				buffer_write(buffer, buffer_u8, _length)
				for (var i=0; i<_length; i++){
					// obj_connected_clientinstances
					var Connected_client = obj_server.Connected_clients[? obj_server.active_connect_ids[| i]]
					buffer_write(buffer, buffer_u8, Connected_client.connect_id)
					buffer_write(buffer, buffer_bool, Connected_client.Player.ready_to_start)
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
					// Iterate through list of players
					var player_amount = buffer_read(buffer, buffer_u8)
					for (var i=0; i<player_amount; i++){
						var conn_id = buffer_read(buffer, buffer_u8)
						var ready_to_start = buffer_read(buffer, buffer_bool)
						if conn_id == obj_client.connect_id{
							obj_upgrade_client.ready = ready_to_start
						}
					}
				}
				break
			case STATE_GAME:
				if obj_menu.state == STATE_GAME {
					if not global.have_server{
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
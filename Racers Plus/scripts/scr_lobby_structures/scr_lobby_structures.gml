
function stc_lobby_mission(_Map, _setup, _level) constructor{
	Map = _Map
	setup = _setup
	level = _level
	get_title = function(){
		return Map.title + " | " + string(setup)
	}
	write_to_buffer = function(buff){
		buffer_write(buff, buffer_u8, Map.index)
		buffer_write(buff, buffer_u8, setup)
		buffer_write(buff, buffer_u8, level)
	}
}
function stc_lobby_mission_read_from_buffer(buff){
	var Map = obj_campaign.Available_maps[buffer_read(buff, buffer_u8)]
	var setup = buffer_read(buff, buffer_u8)
	var level = buffer_read(buff, buffer_u8)
	return new stc_lobby_mission(Map, setup, level)
}

function stc_lobby_section(_title, _slots) constructor{
	title = _title
	slots = _slots
	write_to_buffer = function(buff){
		buffer_write(buff, buffer_string, title)
		var slot_amount = array_length(slots)
		buffer_write(buff, buffer_u8, slot_amount)
		for (var i=0; i<slot_amount; i++){
			slots[i].write_to_buffer(buff)
		}
	}
}
function stc_lobby_section_read_from_buffer(buff){
	var title = buffer_read(buff, buffer_string)
	var slot_amount = buffer_read(buff, buffer_u8)
	var slots = []
	for (var i=0; i<slot_amount; i++){
		slots[i] = stc_lobby_section_slot_read_from_buffer(buff)
	}
	return new stc_lobby_section(title, slots)
}


#region
function lobby_create_slot(_slots, _active=true, _unique=true){
	var slot = new stc_lobby_section_slot(_slots, _active, _unique) 
	ds_map_add(obj_lobby.slots, slot.slot_id, slot)
	return slot
}

/// @param _unique	If false, the child slot is a duplicate of the parent,
///					to allow any number of players
function stc_lobby_section_slot(_slots, _active=true, _unique=false) constructor{
	slots = _slots
	active =_active
	unique = _unique
	// stc_lobby_player
	player = noone
	
	slot_id = obj_lobby.next_slot_id++
	
	copy = function(){
		var _slots = []
		for (var i=0; i<array_length(slots); i++){
			_slots[i] = slots[i].copy()
		}
		return lobby_create_slot(_slots, active, unique)
	}
	
	write_to_buffer = function(buff){
		var slot_amount = array_length(slots)
		buffer_write(buff, buffer_u8, slot_amount)
		for (var i=0; i<slot_amount; i++){
			slots[i].write_to_buffer(buff)
		}
		buffer_write(buff, buffer_bool, unique)
	}
	
	toString = function(){
		return "Slot ID: " + string(slot_id)
	}
}
function stc_lobby_section_slot_read_from_buffer(buff){
	var slot_amount = buffer_read(buff, buffer_u8)
	var slots = []
	for (var i=0; i<slot_amount; i++){
		slots[i] = stc_lobby_section_slot_read_from_buffer(buff)
	}
	var unique = buffer_read(buff, buffer_bool)
	return lobby_create_slot(slots, true, unique)
}
#endregion

#region Player
function lobby_create_player(connect_id){
	var player = new stc_lobby_player(connect_id)
	ds_map_add(obj_lobby.players, connect_id, player)
	return player
}

function stc_lobby_player(_connect_id) constructor{
	connect_id = _connect_id
	// Set with LOBBY_UPDATE_PLAYER
	player_name = ""
	ready_to_start = false
	// stc_lobby_section_slot
	slot = noone
	
	local = false
	
	write_to_buffer = function(buff){
		buffer_write(buff, buffer_u8, connect_id)
		buffer_write(buff, buffer_string, player_name)
		buffer_write(buff, buffer_bool, ready_to_start)
		if slot != noone{
			buffer_write(buff, buffer_bool, true)
			buffer_write(buff, buffer_u8, slot.slot_id)
		}
		else{
			buffer_write(buff, buffer_bool, false)
		}
	}
	clean_up = function(){
		// Destory input boxes
	}
}
function stc_lobby_player_read_from_buffer(buff){
	var connect_id = buffer_read(buff, buffer_u8)
	var player_name = buffer_read(buff, buffer_string)
	var ready_to_start = buffer_read(buff, buffer_bool)
	var slot_exists = buffer_read(buff, buffer_bool)
	
	var player = lobby_create_player(connect_id)
	
	obj_lobby.perform_interaction(LOBBY_UPDATE_PLAYER, connect_id, ready_to_start, player_name)
	if slot_exists{
		var slot_id = buffer_read(buff, buffer_u8)
		obj_lobby.perform_interaction(LOBBY_SLOT_JOIN, connect_id, slot_id)
	}
	return player
}
#endregion
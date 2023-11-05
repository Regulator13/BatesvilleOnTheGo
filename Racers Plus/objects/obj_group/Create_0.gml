/// @description Team details

// title - Group's title

// group_id - Unique and shared across all clients
group_id = obj_campaign.next_group_id++
ds_map_add(obj_campaign.Group_ids, group_id, self)

// obj_player instances
Players = ds_list_create()

write_to_buffer = function(buff){
	buffer_write(buff, buffer_u8, group_id)
	buffer_write(buff, buffer_string, title)
	
	var slot_amount = ds_list_size(Players)
	buffer_write(buff, buffer_u8, slot_amount)
	for (var i=0; i<slot_amount; i++){
		buffer_write(buff, buffer_u8, Player.Parent.connect_id)
	}
}
read_from_buffer = function(buff){
	group_id = buffer_read(buff, buffer_u8)
	title = buffer_read(buff, buffer_string)
	
	ds_list_clear(Players)
	var slot_amount = buffer_read(buff, buffer_u8)
	for (var i=0; i<slot_amount; i++){
		var connect_id = buffer_read(buff, buffer_u8)
		// obj_player instances
		var Player = obj_client.Network_players[? connect_id].Player
		ds_list_add(Players, Player)
	}
}
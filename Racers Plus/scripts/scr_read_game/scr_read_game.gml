
function scr_read_game(buff){
	// Read common data
	var Player = obj_client.Network_players[? obj_client.connect_id]
	
	if obj_client.connect_id != 0{
		var state = buffer_read(buff, buffer_u8)
		
		////DEBUG
		if state != Player.state{
			show_debug_message("obj_player state switch from " + string(Player.state) + " to " + string(state))
		}
		
		Player.state = state
		switch Player.state{
			case STATE_DRIVING:
				break
			case STATE_PICKING_UP:
				var delivery_options = buffer_read(buff, buffer_u8)
				
				////DEBUG
				if ds_list_size(Player.available_deliveries) != delivery_options{
					show_debug_message("obj_player change in delivery options from " + 
							string(ds_list_size(Player.available_deliveries)) +
							" to " + string(delivery_options))
				}
				
				ds_list_clear(Player.available_deliveries)
				for (var i=0; i<delivery_options; i++){
					var order_id = buffer_read(buff, buffer_u8)
					ds_list_add(Player.available_deliveries, order_id)
				}
				break
		}
	}
}
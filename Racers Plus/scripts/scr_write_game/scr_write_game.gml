/// @function scr_write_game(buffer, buffer_tell, Authoritative_player)
/// @description Writes what should be displayed per player
//  Returns buffer with game info
function scr_write_game(buff, starting_position, Authoritative_player) {
	//reset buffer to start - UDP messages have a 3 byte header, GAME_ID, connect_id, and udp_sequence_out
	buffer_seek(buff, buffer_seek_start, starting_position)
	
    // Write common data

	#region Player specific section
	///TODO
	if Authoritative_player.connect_id != 0{
		var Player = Authoritative_player.Player
		var Car = Player.Car
		buffer_write(buff, buffer_u8, Player.state)
		switch Player.state{
			case STATE_DRIVING:
				break
			case STATE_PICKING_UP:
				var delivery_options = ds_list_size(Car.available_deliveries)
				buffer_write(buff, buffer_u8, delivery_options)
	
				for (var i=0; i<delivery_options; i++){
					var Delivery = Car.available_deliveries[| i]
					buffer_write(buff, buffer_u8, get_order_number(Delivery.order_id))
				}
				break
		}
	}
	#endregion
	return buff
}

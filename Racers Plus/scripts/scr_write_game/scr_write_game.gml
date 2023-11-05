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
		buffer_write(buff, buffer_s32, obj_campaign.Teams[? Player.team].team_score)
		var Car = Player.Car
		
		buffer_write(buff, buffer_u8, Car.model)
		buffer_write(buff, buffer_u8, Car.hp)
		buffer_write(buff, buffer_u8, Car.nitrus)
		buffer_write(buff, buffer_u8, Player.state)
		switch Player.state{
			case STATE_DRIVING:
				var delivery_amount = ds_list_size(Car.picked_up_deliveries)
				buffer_write(buff, buffer_u8, delivery_amount)
				for (var i=0; i<delivery_amount; i++){
					buffer_write(buff, buffer_u8, get_order_number(Car.picked_up_deliveries[| i]))
				}
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

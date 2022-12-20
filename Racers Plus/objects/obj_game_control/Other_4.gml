/// @description Set active customers for the round
if global.have_server{
	ds_list_shuffle(global.customer_locations)
	///TODO set based on amount of players
	var _size = 8

	for (var i=0; i<_size; i++){
		var Customer = ds_list_find_value(global.customer_locations, i)
		Customer.alarm[0] = 1
	}
}


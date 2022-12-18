/// @description Set active customers for the round
ds_list_shuffle(global.customer_locations)
///TODO set based on amount of players
var _size = 8
for (var i=0; i<_size; i++){
	Customer = ds_list_find_value(global.customer_locations, i)
	Customer.alarm[0] = 1
}



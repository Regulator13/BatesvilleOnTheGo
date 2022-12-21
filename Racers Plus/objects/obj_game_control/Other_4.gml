/// @description Set active customers for the round
if global.have_server{
	ds_list_shuffle(global.customer_locations)
	////TODO set based on amount of players
	var _size = 8
	var _customer = 0

	for (var i=1; i<=2; i++){
		repeat(_size/2){
			var Customer = ds_list_find_value(global.customer_locations, _customer++)
			Customer.alarm[0] = 1
			Customer.loyal_team = i
		}
	}
}


/// @description Set active customers for the round
if not global.hybrid_online or global.have_hybrid_server{
	ds_list_shuffle(global.customer_locations)
	////TODO set based on amount of players
	var _customer = 0

	for (var i=1; i<team_amount; i++){
		// Extra team 0
		repeat(customer_amount/(team_amount - 1)){
			var Customer = ds_list_find_value(global.customer_locations, _customer++)
			Customer.alarm[0] = 1
			Customer.loyal_team = i
		}
	}
}


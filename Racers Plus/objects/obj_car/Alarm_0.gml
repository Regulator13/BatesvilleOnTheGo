/// @description Check to pickup
ds_list_clear(available_deliveries)
for (var i=0; i<instance_number(obj_delivery); i++){
	var Delivery = instance_find(obj_delivery, i)
	
	if distance_to_point(Delivery.x, Delivery.y) < 32{
		if speed == 0 and Delivery.business_id == Player.team{
			ds_list_add(available_deliveries, Delivery)
			Player.state = STATE_PICKING_UP
		}
	}
}

// Continually check to pick up
alarm[0] = 1


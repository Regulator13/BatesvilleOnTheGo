/// @description Check to pickup

var delivers_currently_available = ds_list_create()

for (var i=0; i<instance_number(obj_delivery); i++){
	var Delivery = instance_find(obj_delivery, i)
	
	if distance_to_point(Delivery.x, Delivery.y) < 32{
		if speed == 0 and Delivery.business_id == Player.team{
			ds_list_add(delivers_currently_available, Delivery.order_id)
			
			if Player.state != STATE_PICKING_UP {
				Player.change_context(CXT_STATE, STATE_PICKING_UP)
			}
		}
	}
}

// Inform player of any changes
var delta_deliveries = ds_list_create()
ds_list_copy(delta_deliveries, available_deliveries)

for (var i=0; i<ds_list_size(delivers_currently_available); i++){
	var index = ds_list_find_index(delta_deliveries, delivers_currently_available[| i]) 
	if index == -1{
		// New delivery
		Player.change_context(CXT_AVAILABLE_DELIVERY, delivers_currently_available[| i], 1)
	}
	else {
		// This delivery still exists
		ds_list_delete(delta_deliveries, index)
	}
}

// Remove any remaining delta deliveries
for (var i=0; i<ds_list_size(delta_deliveries); i++){
	Player.change_context(CXT_AVAILABLE_DELIVERY, delta_deliveries[| i], 0)
}

// Clean up
ds_list_destroy(delivers_currently_available)
ds_list_destroy(delta_deliveries)

// Continually check to pick up
alarm[0] = 1*game_get_speed(gamespeed_fps)


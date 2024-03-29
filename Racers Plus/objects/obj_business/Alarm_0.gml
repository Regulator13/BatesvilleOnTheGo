/// @description Create order - NEVER CALLED

//Find an open location for an order
var Customer = noone
ds_list_shuffle(global.customer_locations)
var _size = ds_list_size(global.customer_locations)
for (var i=0; i<_size; i++){
	Customer = ds_list_find_value(global.customer_locations, i)
	if not Customer.is_ordering{
		break
	}
	Customer = noone
}

if Customer != noone{
	//Find open order number
	var open_number
	//Maximum of 9 orders since using %10 to determine the shop
	var max_orders = 9
	for (open_number=1; open_number<max_orders; open_number++){
		if ds_list_find_index(current_orders, open_number) == -1{
			break
		}
	}
	
	if open_number < max_orders{
		//Create order
		var Order = instance_create_layer(Customer.x, Customer.y, "lay_above", obj_order)
		Order.image_blend = image_blend
		Order.order_id = set_order_id(open_number, business_id)
		Order.reward = round(distance_to_point(Customer.x, Customer.y)/30)
		Order.expiration = 90*game_get_speed(gamespeed_fps)
		Order.alarm[0] = Order.expiration
		Order.Customer = Customer
		ds_list_add(current_orders, open_number)
		Customer.is_ordering = true
		
		//Create delivery to be picked up for the order
		var Delivery = instance_create_layer(x + sprite_width/2, y + sprite_height + 32, "lay_instances", obj_delivery)
		Delivery.image_blend = image_blend
		Delivery.order_id = set_order_id(open_number, business_id)
	}
}

//Prime next order
alarm[0] = irandom_range(150, 300)*game_get_speed(gamespeed_fps)/popularity
/// @description Order

var Customer = self
var business_id = loyal_team
var Business = global.businesses[? business_id]

//Find open order number
var open_number
//Maximum of 9 orders since using %10 to determine the shop
var max_orders = instance_number(obj_customer)
for (open_number=1; open_number<max_orders; open_number++){
	if ds_list_find_index(Business.current_orders, open_number) == -1{
		break
	}
}

if open_number < max_orders{
	//Create order
	var Order = instance_create_layer(Customer.x, Customer.y, "lay_instances", obj_order)
	Order.image_blend = Business.image_blend
	Order.order_id = set_order_id(open_number, business_id)
	Order.reward = round(distance_to_point(Business.x, Business.y)/30)
	Order.expiration = 90*game_get_speed(gamespeed_fps)
	Order.alarm[0] = Order.expiration
	Order.Customer = Customer
	ds_list_add(Business.current_orders, open_number)
	Customer.is_ordering = true
		
	//Create delivery to be picked up for the order
	var Delivery = instance_create_layer(Business.x + sprite_width/2, Business.y + sprite_height + 32, "lay_instances", obj_delivery)
	Delivery.image_blend = Business.image_blend
	Delivery.order_id = set_order_id(open_number, business_id)
}

alarm[0] = irandom_range(300, 900)*game_get_speed(gamespeed_fps)



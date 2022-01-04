/// @description Expire
//Hurt business popularity
var Business = ds_map_find_value(global.businesses, get_business_id(order_id))
//TODO - business popularity reduction
Business.popularity -= reward

///Destroy related delivery
//TODO - don't check for both in found in one place
//Destroy if not yet picked up
var _size = instance_number(obj_delivery)
for (var i=0; i<_size; i++){
	var Delivery = instance_find(obj_delivery, i)
	instance_destroy(Delivery)
}
//Destroy in car
var _size = instance_number(obj_car)
for (var i=0; i<_size; i++){
	var Car = instance_find(obj_car, i)
	var index = ds_list_find_index(Car.picked_up_deliveries, order_id)
	if index != -1{
		ds_list_delete(Car.picked_up_deliveries, index)
	}
}

//Destroy the order
instance_destroy()
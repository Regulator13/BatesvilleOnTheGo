/// @description Destroy data strucutes
//Drop any picked up deliveries
var _size = ds_list_size(picked_up_deliveries)
for (var i=0; i<_size; i++){
	var Delivery = instance_create_layer(x, y, "lay_instances", obj_delivery)
	Delivery.image_blend = global.business_colors[get_business_id(picked_up_deliveries[| i])]
	Delivery.order_id = picked_up_deliveries[| i]
	Delivery.business_id = Player.team
}
ds_list_clear(picked_up_deliveries)

ds_list_destroy(picked_up_deliveries)
ds_list_destroy(available_deliveries)
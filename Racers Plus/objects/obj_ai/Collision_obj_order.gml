/// @description Drop off delivery
var has_delivery = ds_list_find_index(picked_up_deliveries, other.order_id)

if has_delivery != -1{
	//This order is in the list of picked up deliveries
	Player.score += other.reward
	ds_list_delete(picked_up_deliveries, has_delivery)
	instance_destroy(other)
}
	
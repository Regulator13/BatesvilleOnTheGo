/// @description Free up the Customer and order number
Customer.is_ordering = false
var Business = ds_map_find_value(global.businesses, get_business_id(order_id))
ds_list_delete(Business.current_orders, ds_list_find_index(Business.current_orders, get_order_number(order_id)))
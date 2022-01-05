/// @function							get_order_id(in_id)
/// @param {real} number				number to appear on order
/// @param {real} business_id			identifier for the business
/// @return {real} order_id				order_id
function set_order_id(number, business_id){
	return round(number + business_id*10)
}

/// @function							get_order_number(order_id)
/// @param {real} order_id				id to differentiate
/// @return {real} order_number			id of the order
function get_order_number(order_id){
	return order_id mod 10
}

/// @function							get_business_id(order_id)
/// @param {real} order_id				id to differentiate
/// @return {real} business_id			id of the business
function get_business_id(order_id){
	return order_id div 10
}
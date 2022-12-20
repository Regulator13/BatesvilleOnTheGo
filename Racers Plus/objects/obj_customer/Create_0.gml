/// @description Add location to obj_game_control
ds_list_add(global.customer_locations, self)

is_ordering = false

// Customer ID is set in the room via Creation code
customer_id = 0

Home = noone

// Loyality can be decreased slowly by not taking orders,
// or immediately switched by failing a delivery
loyality = 1
// Team customer is loyal to
loyal_team = irandom_range(1, 2)

// -1 if customer is not active
// obj_game_control will set the active customers each round
alarm[0] = -1
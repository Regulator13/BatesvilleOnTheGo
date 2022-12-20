/// @description Initialize business utilizing obj_game_control

// Business counter starts at 1
business_id = global.business_counter++
image_blend = global.business_colors[business_id]
ds_map_add(global.businesses, business_id, self)

popularity = 10

///Orders
#region
/// TODO remove
//alarm[0] = irandom(20)

//Keep track of all order_id's in use
current_orders = ds_list_create()
#endregion
/// @description Initialize business utilizing obj_game_control

business_id = global.business_counter++
image_blend = global.business_colors[business_id]
ds_map_add(global.businesses, business_id, self)

popularity = 10

///Orders
#region
alarm[0] = irandom(20)

//Keep track of all order_id's in use
current_orders = ds_list_create()
#endregion
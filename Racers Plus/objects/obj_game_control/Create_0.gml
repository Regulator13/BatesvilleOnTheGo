/// TODO
//window_set_fullscreen(true)

//Set global variables
global.player_start = [room_width/2, room_height/2]
global.player_counter = 0

global.business_colors = [c_red, c_blue, c_green]
//Businesses are placed in the room,
//upon creation they set their id to the global business counter and increment it
//starts at 1 to work with modulus in order_id system
global.business_counter = 1
//List of businesses to be referenced by business id
global.businesses = ds_map_create()

global.customer_locations = ds_list_create()

#region Controls
//global.controls[player, key]
var player = 0
global.controls[player, LEFT_KEY] = vk_left
global.controls[player, RIGHT_KEY] = vk_right
global.controls[player, UP_KEY] = vk_up
global.controls[player, DOWN_KEY] = vk_down
global.controls[player, ACTION_KEY] = vk_numpad0
player = 1
global.controls[player, LEFT_KEY] = ord("A")
global.controls[player, RIGHT_KEY] = ord("D")
global.controls[player, UP_KEY] = ord("W")
global.controls[player, DOWN_KEY] = ord("S")
global.controls[player, ACTION_KEY] = vk_space
#endregion
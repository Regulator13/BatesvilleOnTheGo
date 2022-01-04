//window_set_fullscreen(true)

//Set global variables
global.player_start = [352, 3744]

global.business_colors = [c_red, c_blue, c_green]
//Businesses are placed in the room,
//upon creation they set their id to the global business counter and increment it
//starts at 1 to work with modulus in order_id system
global.business_counter = 1
//List of businesses to be referenced by business id
global.businesses = ds_map_create()

global.customer_locations = ds_list_create()
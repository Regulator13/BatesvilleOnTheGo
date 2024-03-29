/// @description Initialize menus

randomize()

if os_browser != browser_not_a_browser{
	//display_set_gui_size(display_get_width(), display_get_height())
	html_init()
	width = 0
	height = 0
}

//universal game access
global.Menu = self
global.online = true
global.production = false

scr_set_controls_default(0, CONTROLS_MOUSE)

//state - current "menu" of the game
state = STATE_ONLINE
//holds states in order visited for universal back button
state_queue = ds_stack_create()

//whether or not game is started
start = false

Teams = ds_map_create()

Buttons = ds_list_create(); //holds menu buttons
selected = 0; //selected button
input_buffer = 0; //small buffer to slow down gamepad input
input_buffer_max = 8
keyboard_input = false	//whether to show selection via keyboard
prev_mouse_x = mouse_x	//check to see if mouse move to turn off keyboard input

//Models 0 = Red Car, 1 = Police Car, 2 = Sport's car, 3 = Taxi 4 = Ambulance
//5 = Pickup, 6 = Van, 7 = Orange Car, 8 = Semi
model_sprites = [spr_car, spr_police, spr_racecar, spr_taxi, spr_ambulance, spr_truck, spr_van,
		spr_widecar, spr_semi]

//universal colour array
// Also change in get_html_color
color_array[0] = #ffffff;
color_array[1] = #ffff00;
color_array[2] = #ff0000;
color_array[3] = #33cc33;
color_array[4] = #cc0099;
color_array[5] = #00ffcc;
color_array[6] = #ff9900;
color_array[7] = #9900cc;
color_array[8] = #66ff66;
color_array[9] = #6699ff;
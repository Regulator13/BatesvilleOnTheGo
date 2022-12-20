/// @description Initialize menus

randomize()

if os_browser != browser_not_a_browser{
	//display_set_gui_size(display_get_width(), display_get_height())
	html_init()
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

//universal colour array
color_array[0] = c_white;
color_array[1] = $80ff80;
color_array[2] = c_red;
color_array[3] = c_yellow;
color_array[4] = c_green;
color_array[5] = c_purple;
color_array[6] = c_aqua;
color_array[7] = c_maroon;
color_array[8] = c_orange;
color_array[9] = c_teal;
color_array[10] = c_olive;
color_array[11] = c_ltgray;
color_array[12] = c_dkgray;
color_array[13] = c_navy;
color_array[14] = $ff8080;
color_array[15] = c_white;
/// @description Initialize HTML5
if os_browser == browser_not_a_browser{
	show_error("Warning! Hybrid menu only works on HTML5", true)
}

//display_set_gui_size(display_get_width(), display_get_height())
html_init()
width = 0
height = 0

state = STATE_MAIN
// State history in order visited for universal back button
state_queue = ds_stack_create()

global.online = false
global.have_server = false
global.paused = false
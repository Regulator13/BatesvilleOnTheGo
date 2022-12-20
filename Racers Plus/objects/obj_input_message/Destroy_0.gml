/// @description  Clear all input
io_clear();

ds_list_destroy(actions)
ds_list_destroy(actionTitles)

// unpause
global.paused = false;

if obj_menu.state == STATE_GAME{
	window_set_cursor(cr_none)
}
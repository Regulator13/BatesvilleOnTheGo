/// @description Clear input
prompt = ""; //message to display
actions = ds_list_create(); //actions to enact after key press
actionTitles = ds_list_create(); //title for each action
actionSel = 0; //current action selected
Source = noone; //who created it
input_buffer = 0; //small buffer to slow down gamepad input
input_buffer_max = 8;

// pause game
global.paused = true;

//enable draw event in case it has been disabled due to a pause
if obj_menu.state == STATE_GAME{
	draw_enable_drawevent(true)
	window_set_cursor(cr_default)
}
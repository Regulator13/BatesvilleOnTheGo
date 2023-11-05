/// @description Clear input
prompt = ""; //message to display
actions = ds_list_create(); //actions to enact after key press
actionTitles = ds_list_create(); //title for each action
actionSel = 0; //current action selected
Source = noone; //who created it
input_buffer = 0; //small buffer to slow down gamepad input
input_buffer_max = 4;

// pause game
global.paused = true;

show_debug_message("obj_input_message Created");

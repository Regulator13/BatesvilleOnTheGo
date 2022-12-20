/// @function scr_set_controls_default(player, controller)
/// @description Set the players controls to the default
/// @param player | the player controls to reset
/// @param controller | the type of default controlls
function scr_set_controls_default(argument0, argument1) {
	// set input
	var player = argument0;
	var controller = argument1;
	// set controls
	switch (controller) {
	    case CONTROLS_MOUSE:
	        global.controls[player, LEFT_KEY] = ord("A");
	        global.controls[player, UP_KEY] = ord("W");
	        global.controls[player, RIGHT_KEY] = ord("D");
	        global.controls[player, DOWN_KEY] = ord("S");
			global.controls[player, ACTION_KEY] = vk_space;
	        //global.controls[player, KEY_TYPE] = CONTROLS_MOUSE;
	        break;
	    }



}

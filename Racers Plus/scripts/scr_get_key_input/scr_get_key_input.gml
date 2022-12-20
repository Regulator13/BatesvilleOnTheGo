/// @function scr_get_key_input(key)
/// @description Gets the current state of the key
/// @param key | Unicode value for the key
function scr_get_key_input(argument0) {
	// Returns real, the constant represented value state of the key

	// set input
	var key = argument0;

	// return state
	if (keyboard_check_pressed(key))
	    return (KEY_PRESSED);
	else if (keyboard_check(key))
	    return (KEY_ISPRESSED);
	else if (keyboard_check_released(key))
	    return (KEY_RELEASED);
	else
	    return (KEY_ISRELEASED);




}

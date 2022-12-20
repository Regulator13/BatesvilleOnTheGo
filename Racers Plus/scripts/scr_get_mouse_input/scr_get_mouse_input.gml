/// @function scr_get_mouse_input(button)
/// @description Gets the current state of the button
/// @param button | unicode value for the button
function scr_get_mouse_input(argument0) {
	// Returns real, the constant value state of the key

	// set input
	var key = argument0;

	// return state
	if (device_mouse_check_button_pressed(0, key))
	    return (KEY_PRESSED);
	else if (device_mouse_check_button(0, key))
	    return (KEY_ISPRESSED);
	else if (device_mouse_check_button_released(0, key))
	    return (KEY_RELEASED);
	else
	    return (KEY_ISRELEASED);




}

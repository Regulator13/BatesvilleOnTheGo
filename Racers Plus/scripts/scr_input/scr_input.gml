/// @description scr_get_key_input(key)
/// @param key
function get_key_input(key) {
	/* 
	* Description: gets the current state of the key
	* Parameters:  key - unicode value for the key
	* Returns:     real, the constant value state of the key
	*/
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
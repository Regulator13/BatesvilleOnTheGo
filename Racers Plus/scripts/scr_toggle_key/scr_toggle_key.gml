/// @function scr_toggle_key(value)
/// @description Toggles key state, PRESSED to ISPRESSED, RELEASED to ISRELEASED, etc.
/// @param value | Toggles the key to the next
function scr_toggle_key(argument0) {
	// Returns the new state

	var value = argument0;
	//start
	    {
	    if (value == KEY_PRESSED) return(KEY_ISPRESSED);
	    if (value == KEY_RELEASED) return(KEY_ISRELEASED);
	    else return(KEY_ISRELEASED);
	    }



}

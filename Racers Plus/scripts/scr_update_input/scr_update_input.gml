/// @function scr_update_input(oldState, newState)
/// @description Updates the input state by one step
/// @param oldState
/// @param newState | Target state, not always the one that will be returned
function scr_update_input(argument0, argument1) {
	// Returns determined new state

	// set input
	var oldState = argument0;
	var newState = argument1;

	// take step to new state
	switch (oldState) {
	    case KEY_PRESSED:
	        switch (newState) {
	            case KEY_PRESSED:
	            case KEY_ISPRESSED:
	                return KEY_ISPRESSED;
	            case KEY_RELEASED:
	            case KEY_ISRELEASED:
	                return KEY_RELEASED;
	            }
	    case KEY_ISPRESSED:
	        switch (newState) {
	            case KEY_PRESSED:
					return KEY_PRESSED;
	            case KEY_ISPRESSED:
	                return KEY_ISPRESSED;
	            case KEY_RELEASED:
	            case KEY_ISRELEASED:
	                return KEY_RELEASED;
	            }
	    case KEY_RELEASED:
	        switch (newState) {
	            case KEY_PRESSED:
	            case KEY_ISPRESSED:
	                return KEY_PRESSED;
	            case KEY_RELEASED:
	            case KEY_ISRELEASED:
	                return KEY_ISRELEASED;
	            }
	    case KEY_ISRELEASED:
	        switch (newState) {
	            case KEY_PRESSED:
	            case KEY_ISPRESSED:
	                return KEY_PRESSED;
	            case KEY_RELEASED:
	            case KEY_ISRELEASED:
	                return KEY_ISRELEASED;
	            }
	    default:
	        return newState;
	    }




}

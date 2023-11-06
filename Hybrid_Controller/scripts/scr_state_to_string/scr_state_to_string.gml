/// @function scr_state_to_string(value)
/// @description Returns sting of macro name
/// @param value
function scr_state_to_string(argument0) {
	// Returns string, macro name

	// set input
	var value = argument0;

	// return string
	switch (value) {
		case STATE_MAIN:
			return "STATE_MAIN"
		case STATE_ONLINE:
			return "STATE_ONLINE"
	    case STATE_LOBBY:
	        return "STATE_LOBBY"
	    case STATE_GAME:
	        return "STATE_GAME"
	    case STATE_SCORE:
	        return "STATE_SCORE"
		default:
			return "State not added to scr_network_state"
	    }



}

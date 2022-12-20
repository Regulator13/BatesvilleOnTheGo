/// @function scr_network_state_to_string(value)
/// @description Returns string of macro
/// @param value | value to convert
function scr_network_state_to_string(argument0) {
	// Returns string

	// set input
	var value = argument0;

	// return string
	switch (value) {
	    case NETWORK_TCP_CONNECT:
	        return "NETWORK_TCP_CONNECT"
		case NETWORK_UDP_CONNECT:
	        return "NETWORK_UDP_CONNECT"
		case NETWORK_LOGIN:
	        return "NETWORK_LOGIN";
	    case NETWORK_LOBBY:
	        return "NETWORK_LOBBY";
	    case NETWORK_PLAY:
	        return "NETWORK_PLAY";
		default:
			return "Warning: Debug state not added"
	    }



}

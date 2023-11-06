/// @function scr_network_state_to_string(value)
/// @description Takes the msgID contsant and returns the corresponding string
/// @param network_state
//  Retruns string
function scr_network_state_to_string(network_state) {
	switch (network_state) {
	    case NETWORK_TCP_CONNECT:
	        return "NETWORK_TCP_CONNECT"
		case NETWORK_UDP_CONNECT:
	        return "NETWORK_UDP_CONNECT"
	    case NETWORK_LOGIN:
	        return "NETWORK_LOGIN"
		case NETWORK_LOBBY:
	        return "NETWORK_LOBBY"
		case NETWORK_GAMECONFIG:
	        return "NETWORK_GAMECONFIG"
	    case NETWORK_PLAY:
	        return "NETWORK_PLAY"
		case NETWORK_SCORE:
	        return "NETWORK_SCORE"
	}
}
	
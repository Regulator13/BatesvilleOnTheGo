/// @function scr_msg_id_to_String(msgID)
/// @description Takes the msgID contsant and returns the corresponding string
/// @param msgID
function scr_msg_id_to_string(msgID) {
	switch (msgID) {
	    case CLIENT_CONNECT:
	        return "CLIENT_CONNECT"
	    case SERVER_CONNECT:
	        return "SERVER_CONNECT"
	    case CLIENT_LOGIN:
	        return "CLIENT_LOGIN"
	    case SERVER_LOGIN:
	        return "SERVER_LOGIN"
	    case CLIENT_PLAY:
	        return "CLIENT_PLAY"
	    case SERVER_PLAY:
	        return "SERVER_PLAY"
		case CLIENT_PING:
			return "CLIENT_PING"
		case SERVER_PING:
	        return "SERVER_PING"
		case SERVER_STATESWITCH:
	        return "SERVER_STATESWITCH"
		default:
			return "UNKOWN MESSAGE ID"
	}
}

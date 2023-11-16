/// @function scr_hybrid_msg_id_to_string(msgID)
/// @description Takes the msgID contsant and returns the corresponding string
/// @param msgID
function scr_hybrid_msg_id_to_string(msgID) {
	switch (msgID) {
		case HYBRID_SERVER_CONNECT:
			return "HYBRID_SERVER_CONNECT"
	    case HYBRID_CLIENT_PLAY:
	        return "HYBRID_CLIENT_PLAY"
	    case HYBRID_SERVER_PLAY:
	        return "HYBRID_SERVER_PLAY"
		case HYBRID_CLIENT_PING:
			return "HYBRID_CLIENT_PING"
		case HYBRID_SERVER_PING:
	        return "HYBRID_SERVER_PING"
		default:
			return "UNKOWN MESSAGE ID"
	}
}

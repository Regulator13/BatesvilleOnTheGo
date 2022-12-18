/// @function scr_msg_id_to_string(msgID)
/// @description Converts macro value to string of macro name
/// @param msgID
function scr_msg_id_to_string(msg_id) {
	switch (msg_id) {
	    case CLIENT_CONNECT:
	        return "CLIENT_CONNECT";
	    case SERVER_CONNECT:
	        return "SERVER_CONNECT";
	    case CLIENT_LOGIN:
	        return "CLIENT_LOGIN";
	    case SERVER_LOGIN:
	        return "SERVER_LOGIN";
	    case CLIENT_PLAY:
	        return "CLIENT_PLAY";
	    case SERVER_PLAY:
	        return "SERVER_PLAY";
		case CLIENT_PING:
	        return "CLIENT_PING";
		case SERVER_PING:
	        return "SERVER_PING"
		case CLIENT_WAIT:
	        return "CLIENT_WAIT";
		default:
			return string(msg_id) + " is not added!"
	    }
}

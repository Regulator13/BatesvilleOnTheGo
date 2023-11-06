/// @description Client updates
switch network_state{
	case NETWORK_TCP_CONNECT:
		// Ignore
		break
    case NETWORK_LOGIN:
		#region Login 
        
        #endregion
        break
	case NETWORK_LOBBY:
		#region Game is running
		
		if alarm[3] == -1{
			// Start pinging
			alarm[3] = ping_wait
		}
		#endregion
        break
    case NETWORK_PLAY:
        break;
}

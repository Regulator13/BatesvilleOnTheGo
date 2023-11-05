/// @description Recieving messages
var eventid = ds_map_find_value(async_load, "id")
var ip = ds_map_find_value(async_load, "ip")

var type = ds_map_find_value(async_load, "type")

if type == network_type_non_blocking_connect{
	//TCP connection confirmation
	//Warning! This works on the server only!
	var socket = async_load[? "socket"]
	var succeeded = async_load[? "succeeded"]
	show_debug_message("Connection has succeeded (if 1): " + string(succeeded) + " with socket " + string(socket))
	
	log_message(string("<- TCP Socket {0} Succeeded {1}", socket, succeeded))
}

#region TCP messages
// Need to check network_type_data since connection is asynchronous
if (eventid == tcp_client and type == network_type_data){
	//read buffer data
    var buffer = ds_map_find_value(async_load, "buffer")
        
    //set cursor to start of buffer
    buffer_seek(buffer, buffer_seek_start, 0)
    
	//ensure message is for this game
	if (buffer_read(buffer, buffer_u8) == GAME_ID){
		//read incoming connection id to ensure it is for this client
		var conn_id = buffer_read(buffer, buffer_u8)
	    //read msg_id, confirmation message, or game message
	    var msg_id = buffer_read(buffer, buffer_s8)
		
		log_message(string("<- TCP {0} {1}", scr_msg_id_to_string(msg_id), conn_id))
		
		if conn_id == connect_id{
			//still recieving server messages, update disconnect buffer
		    alarm[0] = disconnect_after_seconds*game_get_speed(gamespeed_fps)
		
			//set last_msg_id_received for debug purposes
		    last_msg_id_received = msg_id;
		
			switch network_state{
				case NETWORK_TCP_CONNECT:
					if msg_id == SERVER_CONNECT {
						//TCP and UDP connection complete, login
						// This is not called, since connect_id = -1 before this message
						// See if catch below
					}
					else if msg_id == CLIENT_CONNECT {
						// Ignore
						// This is the server opening the socket
					}
					break
				case NETWORK_LOGIN:
				case NETWORK_LOBBY:
				case NETWORK_GAMECONFIG:
				case NETWORK_PLAY:
				case NETWORK_SCORE:
					read_reliable_message(msg_id, buffer)
					break
				default:
					show_debug_message("Warning! Client in unknown netwokring state.")
					break
			}
		}
		else{
			if network_state == NETWORK_TCP_CONNECT{
				if msg_id == SERVER_CONNECT{
					connect_id = conn_id
					//store the socket of the server for sending messages to it
					server_tcp_socket = tcp_client
					
					network_state = NETWORK_LOGIN
					
					// No UDP connection, so send our "player name"
					scr_send_login(self.player_name)
					
					log_message(scr_network_state_to_string(network_state))
				}
			}
		}
	}
}
#endregion

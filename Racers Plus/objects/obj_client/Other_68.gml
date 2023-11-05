/// @description Recieving messages
var eventid = ds_map_find_value(async_load, "id")
var ip = ds_map_find_value(async_load, "ip")

var type = ds_map_find_value(async_load, "type")

var type = ds_map_find_value(async_load, "type");
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
				case NETWORK_UDP_CONNECT:
					if msg_id == SERVER_CONNECT{
						//TCP and UDP connection complete, login
						network_state = NETWORK_LOGIN
					
						// Client has connected to the server, so send our "player name"
						// This will confirm a succesful hole punch if attempted
						// This will set obj_authoritative.player_name
					    scr_send_login(player_name)
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
					
					//now attempt to connect via UDP
					network_state = NETWORK_LOGIN//NETWORK_UDP_CONNECT
					// No UDP connection, so send our "player name"
					scr_send_login(self.player_name)
					connect_udp_tries = 0
					
					log_message(scr_network_state_to_string(network_state))
				}
			}
		}
	}
}
#endregion

#region UDP message
//is this message for our socket?
if (eventid == udp_client){
	//read buffer data
    var buffer = ds_map_find_value(async_load, "buffer")
        
    //always start at start of buffer
    buffer_seek(buffer, buffer_seek_start, 0)
    
	//ensure message is for this game
	if (buffer_read(buffer, buffer_u8) == GAME_ID){
		//ensure message is for this client
		//multiple clients could use the same external ip
		var conn_id = buffer_read(buffer, buffer_u8)
		if connect_id == conn_id {
			//read sequence
		    var sequence = buffer_read(buffer, buffer_u8)
		    //read msg_id, confirmation message, or game message
		    var msg_id = buffer_read(buffer, buffer_s8)
			
		    //set last_msg_id_received for debug purposes
		    last_msg_id_received = msg_id
			
			log_message(string("<- UDP {0} {1}", scr_msg_id_to_string(msg_id), conn_id))

			//if more recent message, check
		    if (scr_sequence_more_recent(sequence, last_sequence_received, SEQUENCE_MAX)){
				//this package is newer and therefore requires an update
		        //update last_sequence_received
		        last_sequence_received = sequence
				
				//still recieving server messages, update disconnect buffer
				alarm[0] = disconnect_after_seconds*game_get_speed(gamespeed_fps)
				
				//get state that server is in
			    var state = buffer_read(buffer, buffer_u8);
			
			    switch(state) {
					case NETWORK_TCP_CONNECT:
					case NETWORK_UDP_CONNECT:
						// Ignore
						// This is the server opening the socket
						break
					case NETWORK_LOGIN:
						// Ignore
						break
					case NETWORK_LOBBY:
					case NETWORK_GAMECONFIG:
					case NETWORK_PLAY:
					case NETWORK_SCORE:
						read_regular_message(msg_id, buffer, state)
						break
					default:
						show_debug_message("Warning! Client in unknown netwokring state.")
						break
				}
	        }
	    }
	}
}
#endregion
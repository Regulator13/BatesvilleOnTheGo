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
		
		log_message(string("<- TCP {0} {1}", scr_hybrid_msg_id_to_string(msg_id), conn_id))
		
		//still recieving server messages, update disconnect buffer
		alarm[0] = disconnect_after_seconds*game_get_speed(gamespeed_fps)
		
		//set last_msg_id_received for debug purposes
		last_msg_id_received = msg_id
		
		read_reliable_message(msg_id, buffer)
	}
}
#endregion

/// @description UDP server code - Detect servers "broadcast"
var eventid = ds_map_find_value(async_load, "id");

show_debug_message("Check for broadcast message")

if eventid == broadcast_server{
	var ip = ds_map_find_value(async_load, "ip");

	//Incoming data for the server from a connected saocket
	var buff = ds_map_find_value(async_load, "buffer");
	if buffer_read(buff, buffer_u8) == GAME_ID{
	    var name = buffer_read(buff, buffer_string );
        
	    //Add to our list...if we don't already have it!
	    var index = ds_list_find_index(serverlist, ip);
	    if index < 0{
	        ds_list_add(serverlist, ip);
	        ds_list_add(servernames, name);
			ds_list_add(server_refresh, BROADCAST_RATE*2)
	        show_debug_message("New server found at: " + ip + " called: " + name);
	    }
		else{
			//prevent refresh
			ds_list_replace(server_refresh, index, BROADCAST_RATE*2)
		}
	}
} 

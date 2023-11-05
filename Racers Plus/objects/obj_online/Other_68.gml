 /// @description  UDP server code - Detect servers "broadcast"
var eventid = ds_map_find_value(async_load, "id")
var ip = ds_map_find_value(async_load, "ip")
var buff = ds_map_find_value(async_load, "buffer")

if (eventid == broadcast_socket) {
	var game = buffer_read(buff, buffer_u8)
    var name = buffer_read(buff, buffer_string)

	if game == GAME_ID {
		// Add to our list...if we don't already have it!
		var index = ds_list_find_index(serverlist, ip)
		if index<0 {
		    ds_list_add(serverlist, ip)
		    ds_list_add(servernames, name)
		    show_debug_message("New server found at: "+ip+" called: "+name)
		}
	}
} 


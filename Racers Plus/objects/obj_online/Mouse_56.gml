/// @description Detect clicking on server list
if os_browser != browser_not_a_browser{
	var entry_height = 30

	var yindex = 41 + 40
	var count = ds_list_size(serverlist);
	if (mouse_y > yindex and mouse_y < (yindex+(count * entry_height))) {
	    var picked = floor(((mouse_y - yindex)/entry_height))
		// Store IP outside of list, since obj_online is destroyed in event_user(0)
		var ip = ds_list_find_value(serverlist, picked)
		event_user(0)
	    obj_client.server_ip = ip
		with obj_client event_user(0)
	}
}
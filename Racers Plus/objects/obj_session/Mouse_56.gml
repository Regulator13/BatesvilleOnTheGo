/// @description Detect clicking on server list
if os_browser != browser_not_a_browser{
	var sy = 400
	var yindex = sy+30;
	var count = ds_list_size(serverlist);
	if (mouse_y > yindex and mouse_y < (yindex+(count * 30))){
	    var picked = floor(((mouse_y-yindex)/30));
	    global.connectip = ds_list_find_value(serverlist, picked);
	    alarm[0] = 2;
	}
}
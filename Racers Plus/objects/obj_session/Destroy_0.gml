/// @description Destroy created objects

//destroy ds_lists
ds_list_destroy(serverlist);
ds_list_destroy(servernames);
ds_list_destroy(server_refresh)

//destroy broadcast
//network_destroy(broadcast_server)
// This network is used in obj_server to figure out it's own IP and then it is destroyed

//save player name
if os_browser == browser_not_a_browser{
	scr_save_player(Name_input.text, Direct_IP.text)
}

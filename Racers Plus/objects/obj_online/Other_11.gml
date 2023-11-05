/// @description  Host server
instance_create_layer(0, 0, "lay_instances", obj_server)

// check if succesful
if (global.have_server == false) {
    show_debug_message("Cant create server")
}
else {
	/// Module Integration - Menu
	//set server name
	obj_server.server_name = Name_box.text
	
	/// Module Integration - Menu
    // Switch menu to the lobby
	// This will destroy all menus buttons including the two text boxes
	var name = Name_box.text
	var ip = Direct_ip_box.text
    
	// Create client
    var Client = instance_create_layer(0, 0, "lay_instances", obj_client)
	Client.player_name = name
	obj_client.server_ip = "127.0.0.1"
	
	with obj_client event_user(0)
	
	// save player name
	scr_save_player(name, ip)
	
	// Create client before state switch
	menu_state_switch(STATE_ONLINE, STATE_LOBBY)
	
    // client takes care of all networking now
    instance_destroy()
}

/// @description  Host server
instance_create_layer(0, 0, "lay_instances", obj_server)

// check if succesful
if (global.have_server == false) {
    show_debug_message("Cant create server")
}
else {
	// Create client before state switch
	menu_state_switch(STATE_ONLINE, STATE_LOBBY)
	
    // client takes care of all networking now
    instance_destroy()
}

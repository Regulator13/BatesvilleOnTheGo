/// @description Start game - local client+server
//create server
global.Server = instance_create_layer(0, 0, "lay_networking", obj_server);

//check if successful
if not global.have_server{
    show_debug_message("Cant create server");
    }
else{
	//set server name
	global.Server.server_name = Name_input.text
    //tell client to connect to itself
    global.connectip = "127.0.0.1";
	
    //switch menu to the lobby
    scr_state_switch(STATE_ONLINE, STATE_LOBBY);
	
    //create client
    var client = instance_create_layer(0, 0, "lay_networking", obj_client);
	client.player_name = Name_input.text
	
    //client takes care of all networking now, and stop checking for broadcasts
    instance_destroy();
}

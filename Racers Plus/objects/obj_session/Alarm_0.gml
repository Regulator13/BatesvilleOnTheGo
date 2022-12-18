/// @description Start game - connect to a remote server

//switch menu to the lobby
scr_state_switch(STATE_ONLINE, STATE_LOBBY);

//create  client
var Client = instance_create_layer(0, 0, "lay_networking", obj_client)
if os_browser == browser_not_a_browser{
	Client.player_name = Name_input.text
}
else{
	Client.player_name = player_name
	//save player name
	scr_save_player(player_name, global.connectip)
}
	
// client takes care of all networking now
instance_destroy();

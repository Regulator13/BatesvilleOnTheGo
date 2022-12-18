/// @function scr_login_client(Network_player, name)
/// @description Updates player information, name
/// @returns null
function scr_login_client(Network_player, name){
	//update name in lobby
	show_debug_message("Update name: " + name)
	Network_player.player_name = name
	Network_player.player_color = Network_player.connect_id
	
	//add player to first empty section in the lobby
	if Network_player.connect_id != 0{
		scr_add_to_sections(Network_player)
	}
    
	//client message, confirm login
	ds_queue_enqueue(Network_player.messages_out, SERVER_LOGIN)
}

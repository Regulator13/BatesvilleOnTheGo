/// @function scr_login_client(Connected_client, name)
/// @description Updates player information, name
/// @returns null
function scr_login_client(Connected_client, name){
	//update name in lobby
	show_debug_message("Update name: " + name)
	Connected_client.Player.player_name = name
	Connected_client.Player.player_color = Connected_client.connect_id
	
	//add player to first empty section in the lobby
	if Connected_client.connect_id != 0{
		scr_add_to_sections(Connected_client.Player)
	}
    
	//client message, confirm login
	ds_queue_enqueue(Connected_client.messages_out, SERVER_LOGIN)
}

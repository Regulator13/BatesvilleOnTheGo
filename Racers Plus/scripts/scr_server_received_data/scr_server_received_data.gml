/// @function scr_server_received_data(Connected_client, buff)
/// @description Read client message data - already read GAME_ID and msgID
/// @param Connected_client | obj_connected_client message is from
/// @returns null
function scr_server_received_data(Connected_client, buff) {
	//buffer already in position for reading further
	//read the command, msg_id was already read in obj_server
	var cmd = buffer_read(buff, buffer_u8)

	// handle depending on command
	switch (cmd) {
		case ACTION_CMD:
			// Actions are fed back to the obj_player providing context for performance
			// obj_authoritative_player instances
			var Authoritative_player = Connected_client.Player
			// obj_player instances
			var Player = Authoritative_player.Player
			
			var action = buffer_read(buff, buffer_u8)
			
			Player.read_action(action, buff)
			
			log_message(string("<- TCP ACTION_CMD {0}", scr_action_to_string(action)))
			break
	}
}
/// @description Press button
//perform action
switch(actions[| actionSel]) {
	// switch to lobby menu
    case "lobby":
        menu_state_switch(obj_menu.state, STATE_LOBBY);
        break;
		
    case "delOptions":
        //delete file
        file_delete(obj_menu.gameMode + ".ini");
        game_restart();
        break;
		
    case "delMissions":
        //delete file
        file_delete("paths.ini");
        game_restart();
        break;
		
    case "delControls":
        //delete file
        file_delete("controls.ini");
        game_restart();
        break;
	
	//open controls menu
    case "controls":
        with(obj_menu) {
            menu_init_controls();
            //reset selected
            selected = 0;
            }
        break;
		
    case "online":
        with(obj_menu) menu_init_online();
        break;
		
	//host server
    case "createServer":
        global.InitObject.alarm[1] = 2;
        break;
		
	//connect to server directly
    case "directConnect":
        global.InitObject.alarm[2] = 2;
        break;
	
	//new path
    case "new":
        with(instance_create_layer(room_width/2, room_height/2, "lay_instances", obj_input_button)) action = "createPath";
        break;
	
    case "backMainLobby":
        menu_state_switch(STATE_LOBBY, STATE_MAIN);
        break;
	
	// return to main menu from the online menu
    case "backMainOnline":
        menu_state_switch(STATE_ONLINE, STATE_MAIN);
        break;
	
	// return to online menu from the lobby
    case "backOnlineLobby":
        menu_state_switch(STATE_LOBBY, STATE_ONLINE);
        break;
	
	// return to online menu from the paths
    case "backOnlinePaths":
        menu_state_switch(STATE_GAMECONFIG, STATE_ONLINE);
        break;
	
	// return to online menu from the game
    case "backOnlineGame":
        menu_state_switch(STATE_GAME, STATE_ONLINE);
        break;
	
	// return to online menu from the score screen
    case "backOnlineScore":
        menu_state_switch(STATE_SCORE, STATE_ONLINE);
        break;
	
    // reset client disconnect buffer
    case "resetDisconnectBuffer":
        obj_client.alarm[0] = obj_client.disconnect_after_seconds*game_get_speed(gamespeed_fps)
        break;
	
	// reset networkPlayer drop buffer
    case "reset_reliable_drop_buffer":
        Source.alarm[SOCKET_RELIABLE] = Source.drop_wait[SOCKET_RELIABLE]
        break
	case "reset_regular_drop_buffer":
        Source.alarm[SOCKET_REGULAR] = Source.drop_wait[SOCKET_REGULAR]
        break
		
    case "dropPlayer":
        with (Source) event_user(1);
        break;
	
	case "visitPhame":
		//shell_do("open", global.source)
		game_end()
		break
		
    case "restart":
        game_restart();
        break;
		
    case "quit":
        game_end();
        break;
	
	case "none":
		// Pass
		break
}

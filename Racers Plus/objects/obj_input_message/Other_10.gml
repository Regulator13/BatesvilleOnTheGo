/// @description Press button
//perform action
switch actions[| actionSel]{
	// switch to lobby menu
    case "lobby":
        menu_state_switch(global.Menu.state, STATE_LOBBY);
        break;
	
	//play button
    case "game":
        with(obj_menu) event_user(2);
        break;
	
    case "missions":
        with(obj_menu) event_user(1);
        break;
	
    case "mainOptions":
        with(obj_menu) event_user(4);
        break;
		
    case "options":
        with(obj_menu) event_user(5);
        break;
		
    case "debugOptions":
        with(obj_menu) event_user(6);
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
        menu_state_switch(STATE_PATHS, STATE_ONLINE);
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
		global.Client.alarm[0] = global.Client.disconnect_after_seconds*game_get_speed(gamespeed_fps)
        break
	
	// reset networkPlayer drop buffer
    case "resetDropBuffer":
        Source.alarm[0] = Source.dropBuffer;
        break;
		
    case "dropPlayer":
        with (Source) event_user(1);
        break;
		
    case "restart":
        game_restart();
        break;
		
    case "quit":
        game_end();
        break;
}

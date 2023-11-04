/// @description Button click
switch action{
	case "host":
		global.Networking.alarm[1] = 1;
		break
	case "quit":
		game_end()
		break
	case "direct":
		global.connectip = global.Networking.Direct_IP.text;
		global.Networking.alarm[0] = 1;
		break
	case "back":
		menu_state_switch(global.Menu.state, ds_stack_top(global.Menu.state_queue))
		break
	case "restart":
		game_restart()
		break
	case "ready":
		scr_client_send_input(obj_client.connect_id, READY_UP, x, y)
		break
	case "join-section":
		scr_client_send_input(obj_client.connect_id, SECTION_CHANGE, ds_list_find_index(obj_lobby.Sections, Source), -1)
		break
		
}

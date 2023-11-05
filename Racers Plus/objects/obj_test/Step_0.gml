/// @description Next state
switch obj_menu.state{
	case STATE_MAIN:
		if not ready_up[4]{
			with obj_menu.Buttons[| 0]{
				event_user(0)
			}
			ready_up[4] = true
		}
		break
	case STATE_ONLINE:
		if not ready_up[5]{
			// Host
			with obj_online event_user(1)
			ready_up[5] = true
		}
		break
	/*
	case STATE_LOBBY:
		// Wait for client to complete connection
		if obj_client.network_state == NETWORK_LOBBY and not ready_up[STATE_LOBBY]{
			// Ready up
			var network_player_count = ds_list_size(obj_server.active_connect_ids)
			for (var i=0; i<network_player_count; i++){
				//get the network player
				var Network_player = ds_map_find_value(obj_server.Network_players, obj_server.active_connect_ids[| i])
				Network_player.ready_to_start = true
			}
			ready_up[STATE_LOBBY] = true
		}
		break
	case STATE_GAME:
		if not ready_up[STATE_GAME]{
			// Inform clients game is starting
			var network_player_count = ds_list_size(obj_server.active_connect_ids)
			for (var i=0; i<network_player_count; i++){
				// obj_authoritative_player
				var Network_player = ds_map_find_value(obj_server.Network_players, obj_server.active_connect_ids[| i])
				// Actual game start message is handled in obj_server
				ds_queue_enqueue(Network_player.messages_out, SERVER_STATESWITCH)
			}
			ready_up[STATE_GAME] = true
		}
		break
	case STATE_SCORE:
	/*
		if not ready_up[STATE_SCORE]{
			// Inform clients game is starting
			var network_player_count = ds_list_size(obj_server.active_connect_ids)
			for (var i=0; i<network_player_count; i++){
				// obj_authoritative_player
				var Network_player = ds_map_find_value(obj_server.Authoritative_players, obj_server.active_connect_ids[| i])
				// Actual game start message is handled in obj_server
				ds_queue_enqueue(Network_player.messages_out, SERVER_STATESWITCH)
			}
			ready_up[STATE_SCORE] = true
		}
		/**/
		break
}


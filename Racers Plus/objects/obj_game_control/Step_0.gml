/// @description Game win conditions
//change state
/*
if (changeState) {
	if not global.online {
		with obj_tutorial {
			if other.winner == TEAM_DETECTIVE {
				if checkpoint {
					hint = 17
					obj_robber.x = 526
					obj_robber.y = 190
					obj_robber.suspicion = 0
					obj_robber.caught = false
					obj_robber.wanted = false
					obj_gaurdPath.sprite_index = spr_guard
					with par_NPC {
						Target_to_catch = noone
					}
				}
				else {
					hint = 0
					room_restart()
				}
				other.winner = -1
			}
			else {
				obj_menu.tutorial_completed = true
				scr_state_switch(STATE_GAME, STATE_MAIN)
				instance_destroy()
			}
		}
	}
	else {
		//inform clients game is starting
		for (var i = 0; i < ds_list_size(obj_server.active_connect_ids); i++){
			//get the network player
			var Network_player = ds_map_find_value(obj_server.Authoritative_players, obj_server.active_connect_ids[| i])
			//actual game start message is handled in obj_server
			ds_queue_enqueue(Network_player.messages_out, SERVER_STATESWITCH)
		}
	}
	
	// Ensure multiple messages are not queued
	changeState = false
}
*/


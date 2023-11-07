/// @description Persistent container for game
// Overarching object for the game component

// Created when entering the lobby
// Destroyed when not in lobby, game config, or score screen

#region Networking
// List of all interactables
global.next_interactable_id = 0
global.Interactables = ds_list_create()
#endregion

event_inherited()

// Functions
game_declare_functions()
game_declare_interface_functions()

Available_maps = load_maps()

// Selected mission
mission = noone
// Generated missions
missions = []

// max 255
next_group_id = 0
Groups = ds_list_create()
Group_ids = ds_map_create()

lobby_slot_map = ds_map_create()

#region Interactions
perform_interaction = function(interaction){
	switch interaction{
		case GAME_JOIN:
			var connect_id = argument[1]
			
			// obj_player instances
			var Player = obj_server.Connected_clients[? connect_id].Player
			Player.Group = Groups[| 0]
			Player.slot_index = 0
			break
		case GAME_UPDATE_PLAYER_TEAM:
			var connect_id = argument[1]
			
			// obj_player instances
			var Authoritative_player = obj_server.Connected_clients[? connect_id].Player
			Authoritative_player.team = argument[2]
			break
		case GAME_UPDATE_PLAYER_COLOR:
			var connect_id = argument[1]
			
			// obj_player instances
			var Authoritative_player = obj_server.Connected_clients[? connect_id].Player
			Authoritative_player.player_color = argument[2]
			break
		case GAME_UPDATE_PLAYER_MODEL:
			var connect_id = argument[1]
			
			// obj_player instances
			var Authoritative_player = obj_server.Connected_clients[? connect_id].Player
			Authoritative_player.Player.model = argument[2]
			break
		case GAME_CAR_STATE_CHANGE:
			var connect_id = argument[1]
			var new_state = argument[2]
			
			// obj_player instances
			var Authoritative_player = obj_server.Connected_clients[? connect_id].Player
			break
		case GAME_PICKUP:
			var connect_id = argument[1]
			var order_number = argument[2]
			
			// obj_authoritative_player instances
			var Authoritative_player = obj_server.Connected_clients[? connect_id].Player
			// obj_player instances
			var Player = Authoritative_player.Player
			
			var order_id = set_order_id(order_number, Authoritative_player.team)
			var Car = Player.Car
			
			if order_number == 255{
				// Done with pickup
				Authoritative_player.Player.push_interaction(GAME_CAR_STATE_CHANGE, STATE_DRIVING)
				// Do not check again to pickup for some time
				Car.alarm[0] = 3*game_get_speed(gamespeed_fps)
			}
			else{
				///TODO Cleanup
				var delivery_options = ds_list_size(Car.available_deliveries)
	
				for (var i=0; i<delivery_options; i++){
					var Delivery = Car.available_deliveries[| i]
					if Delivery.order_id == order_id{
						ds_list_add(Car.picked_up_deliveries, Delivery.order_id)
						instance_destroy(Delivery)
					}
				}
			}
			break
		case GAME_DRIVE_UPDATE:
			var connect_id = argument[1]
			var throttle = argument[2]
			var steer = argument[3]/100
			
			// obj_authoritative_player instances
			var Authoritative_player = obj_server.Connected_clients[? connect_id].Player
			// obj_player instances
			var Player = Authoritative_player.Player
			
			
			steer = sign(steer)*power(steer,2)
			
			var Car = Player.Car
			if instance_exists(Car){
				//Car.inputs[LEFT_KEY] = left
				//Car.inputs[RIGHT_KEY] = right
				if throttle == -1{
					Car.inputs[UP_KEY] = KEY_ISPRESSED
					Car.inputs[DOWN_KEY] = KEY_ISRELEASED
				}
				else if throttle == 1{
					Car.inputs[UP_KEY] = KEY_ISRELEASED
					Car.inputs[DOWN_KEY] = KEY_ISPRESSED
				}
				else{
					Car.inputs[UP_KEY] = KEY_ISRELEASED
					Car.inputs[DOWN_KEY] = KEY_ISRELEASED
				}
				Car.steer = steer
			}
			break
	}
}

#region Networking
#region Read interactions
read_interaction = function(interaction, buff){
	switch interaction{
		case GAME_JOIN:
			var connect_id = buffer_read(buff, buffer_u8)
			perform_interaction(interaction, connect_id)
			break
		case GAME_UPDATE_PLAYER_TEAM:
		case GAME_UPDATE_PLAYER_COLOR:
		case GAME_UPDATE_PLAYER_MODEL:
			var connect_id = buffer_read(buff, buffer_u8)
			var value = buffer_read(buff, buffer_u8)
			perform_interaction(interaction, connect_id, value)
			break
		case GAME_DRIVE_UPDATE:
			var connect_id = buffer_read(buff, buffer_u8)
			var throttle = buffer_read(buff, buffer_s16)
			var steer = buffer_read(buff, buffer_s16)
			perform_interaction(interaction, connect_id, throttle, steer)
			break
		case GAME_PICKUP:
			var connect_id = buffer_read(buff, buffer_u8)
			var order_number = buffer_read(buff, buffer_u8)
			perform_interaction(interaction, connect_id, order_number)
			break
	}
}
#endregion
#endregion
#endregion
#endregion

#region Lobby log
log_message = function(entry) {
	file_text_write_string(global.lobby_log, string("obj_campaign {0}", entry))
	file_text_writeln(global.lobby_log)
}
#endregion
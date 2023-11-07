/// @description Set Vehicle Model Variables

// Who created this player
Parent = noone

// Drawing coordinates
throttle_y = 128
throttle_x = 128
j_x = 520
j_y = 128

// Variables for actions
// -1 to accelerate, 0 to maintain, 1 to deccelerate
throttle = 0
steer = 0

// Context provided by server
model = 0 //The current model of the vehicle
state = STATE_DRIVING
available_deliveries = ds_list_create()
picked_up_deliveries = ds_list_create()

#region Update context
// obj_player here is in charge of updating the necessary context for obj_hybrid_player
update_context = function(context){
	switch context{
		case CXT_TEAM:
			var new_team = argument[1]
			Parent.team = new_team
			break
		case CXT_COLOR:
			var new_color = argument[1]
			Parent.player_color = new_color
			break
		case CXT_MODEL:
			var new_model = argument[1]
			model = new_model
			break
		case CXT_AVAILABLE_DELIVERY:
			var order_number = argument[1]
			var add = argument[2]
			if add
				ds_list_add(available_deliveries, order_number)
			else
				ds_list_delete(available_deliveries, ds_list_find_index(available_deliveries, order_number))
			break
		case CXT_DELIVER:
			var order_number = argument[1]
			ds_list_delete(picked_up_deliveries, order_number)
			break
		case CXT_PICKUP:
			var order_number = argument[1]
			ds_list_add(picked_up_deliveries, order_number)
			break
		case CXT_STATE:
			var new_state = argument[1]
			state = new_state
			break
	}
}
#endregion

#region Read context
read_context = function(context, buff){
	switch context{
		case CXT_TEAM:
		case CXT_COLOR:
		case CXT_MODEL:
		case CXT_DELIVER:
		case CXT_PICKUP:
		case CXT_STATE:
			var value = buffer_read(buff, buffer_u8)
			update_context(context, value)
			break
		case CXT_AVAILABLE_DELIVERY:
			var delivery = buffer_read(buff, buffer_u8)
			var add = buffer_read(buff, buffer_u8)
			update_context(context, delivery, add)
			break
	}
}
#endregion

#region Actions
request_action = function(action){
	switch action{
		case ACT_LOBBY_JOIN:
			// Join an entirely new player to the lobby
			// TODO: u8 is not needed
			request_action_u8(action, obj_client.connect_id)
			break
		case ACT_LOBBY_MISSION_CHANGE:
			var mission_index = argument[1]
			request_action_u8(action, mission_index)
			break
		case ACT_LOBBY_ROLE_CHANGE:
			var slot_id = argument[1]
			request_action_u8_u8(action, obj_client.connect_id, slot_id)
			break
		case ACT_LOBBY_UPDATE_PLAYER:
			var ready_to_start = argument[1]
			var player_name = argument[2]
			request_action_u8_u8_string(action, obj_client.connect_id, ready_to_start, player_name)
			break
		case ACT_GAME_UPDATE_PLAYER_TEAM:
		case ACT_GAME_UPDATE_PLAYER_COLOR:
		case ACT_GAME_UPDATE_PLAYER_MODEL:
			var value = argument[1]
			request_action_u8(action, value)
			break
		case ACT_GAME_DRIVE_UPDATE:
			var throttle = argument[1]
			var steer = argument[2]*100
			// s8 would also work
			request_action_s16_s16(action, throttle, steer)
			break
		case ACT_GAME_PICKUP:
			var value = argument[1]
			request_action_u8(action, value)
			break
	}
}
#endregion
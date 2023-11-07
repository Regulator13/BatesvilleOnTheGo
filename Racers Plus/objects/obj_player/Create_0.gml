/// @description Set Vehicle Model Variables

////TODO
// -1 to accelerate, 0 to maintain, 1 to deccelerate
throttle = 0
throttle_y = 128
throttle_x = 128
j_x = 520
j_y = 128

hp = 0
nitrus = 0

//Changeable Vehicle Variables

model = 0 //The current model of the vehicle
//Models 0 = Red Car, 1 = Police Car, 2 = Sport's car, 3 = Taxi 4 = Ambulance
//5 = Pickup, 6 = Van, 7 = Orange Car, 8 = Semi
model_turn_speeds = [1.5, 2, 3, 2, 1.5, 1.25, 1.25, 1.5, 1] //How many degrees the car turns each step
model_accels = [.01, .017, .023, .014, .0125, .01, .0125, .015, .008] //How fast the car speeds up
model_brakes = [.05, .075, .065, .075, .04, .04, .05, .05, .025] //How fast the car slows down
model_nitrus_maxes = [0, 50, 100, 30, 20, 20, 30, 30, 100] //Number of steps the player can use nitrus
model_max_gears = [3, 5, 6, 4, 3, 5, 4, 4, 5] 
model_gear_max_speeds = [[-1, 1, 1.5, 3], [-1.5, 1, 2, 3, 4, 5.5], [-1, 1, 1.5, 3, 4.5, 6, 7], [-1, 1, 1.5, 2.5, 4], [-1, 1, 1.5, 3.5], [-1, 1, 1.5, 2.5, 4, 5.5], [-1.5, 1.5, 2.5, 4, 6], [-1, 1, 1.5, 2.5, 4], [-.25, .5, 1, 2, 3.5, 5]]
model_gear_min_speeds = [[0, 0, 0.5, 1], [0, 0, 1, 2, 3, 4], [0, 0, .5, 1, 2, 3, 5], [0, 0, .5, 1, 2], [0, 0, .5, 1], [0, 0, .5, 1, 2, 3], [0, 0, 1, 2, 3], [0, 0, .5, 1, 2], [0, 0, .3, .5, 1, 2.5]]
model_shift_periods = [35, 25, 25, 30, 35, 40, 30, 30, 50] //Number of steps it takes to shift up a gear
model_tractions = [.6, .7, .5, .6, .8, .65, .6, .7, .6] //Portion of max speed the vehicle can travel without losing traction
model_hp_maxes = [20, 45, 30, 40, 70, 60, 50, 35, 100] //Vehicle's maximum health
model_weights = [8, 8, 6, 10, 18, 16, 20, 15, 50]
model_cost = [10, 20, 30, 40, 50, 60, 70, 80, 90]
vehicle_sprites = [spr_car, spr_police, spr_racecar, spr_taxi, spr_ambulance, spr_truck, spr_van, spr_widecar, spr_semi]
Car = noone

tips = 0

inputs = array_create(5, KEY_ISRELEASED)
if not global.online{
	//Controls are stored in a multidimensional array
	//controls is the index to use to determine the controls preset
	controls = global.player_counter++
}
else{
	controls = 0
}
////TODO
steer = 0

// Who created this player
Parent = noone

// Which virtual controller to use
// stc_controller
controller = obj_controls.controllers[5]

state = STATE_DRIVING

#region Networking
#region Change context
// obj_player here is in charge of updating the necessary context for obj_hybrid_player
change_context = function(context){
	switch context{
		case CXT_TEAM:
			var new_team = argument[1]
			Parent.team = new_team
			if global.online
				update_context_u8(Parent.Parent, context, new_team)
			break
		case CXT_COLOR:
			var new_color = argument[1]
			Parent.player_color = new_color
			if global.online
				update_context_u8(Parent.Parent, context, new_color)
			break
		case CXT_MODEL:
			var new_model = argument[1]
			model = new_model
			if global.online
				update_context_u8(Parent.Parent, context, new_model)
			break
		case CXT_AVAILABLE_DELIVERY:
			var order_id = argument[1]
			var add = argument[2]
			if add
				ds_list_add(Car.available_deliveries, order_id)
			else
				ds_list_delete(Car.available_deliveries, ds_list_find_index(Car.available_deliveries, order_id))
			if global.online
				update_context_u8_u8(Parent.Parent, context, get_order_number(order_id), add)
			break
		case CXT_DELIVER:
			var order_number = argument[1]
			ds_list_delete(Car.picked_up_deliveries, order_number)
			if global.online
				update_context_u8(Parent.Parent, context, order_number)
			break
		case CXT_PICKUP:
			var order_number = argument[1]
			ds_list_add(Car.picked_up_deliveries, order_number)
			if global.online
				update_context_u8(Parent.Parent, context, order_number)
			break
		case CXT_STATE:
			var new_state = argument[1]
			state = new_state
			if global.online
				update_context_u8(Parent.Parent, context, new_state)
			break
	}
}
#endregion

#region Perform actions
perform_action = function(action){
	switch action{
		case ACT_GAME_JOIN:
			Parent.Group = obj_campaign.Groups[| 0]
			break
		case ACT_GAME_UPDATE_PLAYER_TEAM:
			var new_team = argument[1]
			change_context(CXT_TEAM, new_team)
			break
		case ACT_GAME_UPDATE_PLAYER_COLOR:
			var new_color = argument[1]
			change_context(CXT_COLOR, new_color)
			break
		case ACT_GAME_UPDATE_PLAYER_MODEL:
			var new_model = argument[1]
			change_context(CXT_MODEL, new_model)
			break
		case ACT_GAME_PICKUP:
			var order_number = argument[1]
			
			var order_id = set_order_id(order_number, Parent.team)
			
			if order_number == 255{
				// Done with pickup
				change_context(CXT_STATE, STATE_DRIVING)
				// Do not check again to pickup for some time
				Car.alarm[0] = 3*game_get_speed(gamespeed_fps)
			}
			else{
				///TODO Cleanup
				var delivery_options = ds_list_size(Car.available_deliveries)
	
				for (var i=0; i<instance_number(obj_delivery); i++){
					var Delivery = instance_find(obj_delivery, i)
					
					if Delivery.order_id == order_id{
						change_context(CXT_PICKUP, Delivery.order_id)
						instance_destroy(Delivery)
					}
				}
			}
			break
		case ACT_GAME_DRIVE_UPDATE:
			var throttle = argument[1]
			var steer = argument[2]/100
			
			steer = sign(steer)*power(steer,2)
			
			if instance_exists(Car){
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
#endregion

#region Read actions
read_action = function(action, buff){
	switch action{
		case ACT_LOBBY_INITIALIZE:
			var seed = buffer_read(buff, buffer_u8)
			obj_lobby.perform_action(action, seed)
			break
		case ACT_LOBBY_MISSION_CHANGE:
			// Join an entirely new player to the lobby
			var mission_index = buffer_read(buff, buffer_u8)
			obj_lobby.perform_action(action, mission_index)
			break
		case ACT_LOBBY_JOIN:
			// Join an entirely new player to the lobby
			var connect_id = buffer_read(buff, buffer_u8)
			obj_lobby.perform_action(action, connect_id)
			break
		case ACT_LOBBY_SECTION_ADD:
			break
		case ACT_LOBBY_ROLE_CHANGE:
			var connect_id = buffer_read(buff, buffer_u8)
			var slot_id = buffer_read(buff, buffer_u8)
			obj_lobby.perform_action(action, connect_id, slot_id)
			break
		case ACT_LOBBY_UPDATE_PLAYER:
			var connect_id = buffer_read(buff, buffer_u8)
			var ready_to_start = buffer_read(buff, buffer_u8)
			var player_name = buffer_read(buff, buffer_string)
			obj_lobby.perform_action(action, connect_id, ready_to_start, player_name)
			break
		case ACT_GAME_JOIN:
			perform_action(action)
			break
		case ACT_GAME_UPDATE_PLAYER_TEAM:
		case ACT_GAME_UPDATE_PLAYER_COLOR:
		case ACT_GAME_UPDATE_PLAYER_MODEL:
		case ACT_GAME_PICKUP:
			var value = buffer_read(buff, buffer_u8)
			perform_action(action, value)
			break
		case ACT_GAME_DRIVE_UPDATE:
			var throttle = buffer_read(buff, buffer_s16)
			var steer = buffer_read(buff, buffer_s16)
			perform_action(action, throttle, steer)
			break
	}
}
#endregion
#endregion
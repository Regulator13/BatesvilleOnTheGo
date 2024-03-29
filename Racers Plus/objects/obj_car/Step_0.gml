#region Controls
//Nitrus
if inputs[ACTION_KEY]{
	nitrus_on = true
}
else{
	nitrus_on = false
}

//Accelerate
if inputs[UP_KEY]{
	//Only accelerate if not steering too much
	if (direction mod 90 < 20 or direction mod 90 > 70) or speed < gear_max_speed[2]{
		if speed < gear_max_speed[gear] or (nitrus_on and nitrus > 0){
			if nitrus_on and nitrus > 0{
				speed += accel*nitrus_boost
				nitrus -= 1
			}
			else{
				speed += accel
			}
		}
		else if speed >= gear_max_speed[gear]{
			current_shift_period += 1 + nitrus_on*nitrus_boost
		}
	}
	else if (direction mod 90 > 20 or direction mod 90 < 70) and speed > gear_min_speed[2]{
		// Slow down player during fast turns
		//speed -= fric
	}
	//Whenever accelerating, reset the reverse shift period
	current_reverse_period = 0
}

//Decelerate
if inputs[DOWN_KEY]{
	//Brake if not in reverse
	if speed > brake and gear >= 1{
		speed -= brake
	}
	else if gear >= 1{
		speed = 0
	}
	//If the car is already stopped, start to shift to reverse
	if speed <= 0{
		if gear == 0 and (speed - accel >= gear_max_speed[0] or (nitrus_on and nitrus > 0)){
			if nitrus_on and nitrus > 0{
				speed -= accel*nitrus_boost
				nitrus -= 1
			}
			else{
				speed -= accel
		}
		}
		else{
			current_reverse_period += 1 + nitrus_on*nitrus_boost
		}
	}
	//Whenever the brake is touched, reset the shift period
	current_shift_period = 0
}

//Turning
//Get turn amount
if not global.online{
	if inputs[RIGHT_KEY]{
		if steer < 1{
			steer += steer_incr
		}
	}
	else if inputs[LEFT_KEY]{
		if steer > -1{
			steer -= steer_incr
		}
	}
	else{
		steer = 0
	}
}

//If in top two gears, slow down turning
var max_full_turn_speed = gear_max_speed[max_gear - 2]
if speed >= max_full_turn_speed{
	car_dir -= turn_speed*steer*((1 + (speed - max_full_turn_speed)/(max_speed - max_full_turn_speed)))*.5
	//If traveling too fast, lose traction
	if speed > traction*max_speed{
		direction -= turn_speed*steer*((1 + (speed - max_full_turn_speed)/(max_speed - max_full_turn_speed))*.5)*(1 - (speed - traction*max_speed)/max_speed)
	}
	else{
		direction -= turn_speed*steer*((1 + (speed - max_full_turn_speed)/(max_speed - max_full_turn_speed))*.5)
	}
}
if speed >= min_turn_speed{
	car_dir -= turn_speed*steer
	//If traveling too fast, lose traction
	if speed > traction*max_speed{
		direction -= turn_speed*steer*(1 - (speed - traction*max_speed)/max_speed)
	}
	else{
		direction -= turn_speed*steer
	}
}
else{
	direction -= speed/min_turn_speed * turn_speed * steer
	car_dir -= speed/min_turn_speed * turn_speed * steer
}
#endregion

#region Physics
///Friction
//Slow down the car every step
if abs(speed) > fric{
	speed -= sign(speed)*fric
}
else{
	speed = 0
}

///Shifting
//Shift the car up if speeding up or past the max speed for the gear
if current_shift_period >= shift_period or (speed > gear_max_speed[gear]){
	if gear < max_gear{
		gear += 1
		current_shift_period = 0
	}
}
//Shift the car to reverse if trying to reverse long enough
if current_reverse_period >= shift_period{
	//Must be in 1st to shift to reverse
	if gear == 1{
		gear = 0
	}
}
//Shift the car down if it falls below its gear's min speed
if speed < gear_min_speed[gear]{
	//Don't shift into reverse when slowing down
	if gear > 1{
		gear -= 1
	}
}

///Drifting
if speed <= max_speed{
	//If the car is nearly aligned or if the car stops, align it
	if find_degrees_between(direction, car_dir) <= retraction_rate or speed == 0{
		direction = car_dir
	}
	//Otherwise slowly realign the car
	else if find_degrees_between(direction, car_dir) > retraction_rate{
		if find_degrees_between(direction + retraction_rate, car_dir) <= find_degrees_between(direction - retraction_rate, car_dir){
			direction += retraction_rate
		}
		else{
			direction -= retraction_rate
		}
	}
}

//Align the vehicle to 90 degree angles

if align_buffer<= 0{
	if speed > gear_min_speed[2]{ //Only align if traveling fast
		if 90 - (direction mod 90) <= align_margin or direction mod 90 <= align_margin{
			
			direction = round(direction/90)*90
			car_dir = round(direction/90)*90
			align_buffer = align_buffer_max
		}
	}
}


if steer < .2 and speed > gear_min_speed[2] and (direction mod 90 != 0){
	align_buffer -= 1
}
else{
	align_buffer = align_buffer_max
}

#endregion

#region Collisions
///Collisions with solid walls
if place_meeting(x + lengthdir_x(speed + COL_BUFF*sign(speed), direction), y + lengthdir_y(speed + COL_BUFF*sign(speed), direction), par_solid){
	//Damage the vehicle
	hp -= max(abs(speed)*3 - 1, 0)
	speed = 0
}

///Collisions with other vehicles
var Inst = instance_place(x + lengthdir_x(speed + COL_BUFF*sign(speed), direction), y + lengthdir_y(speed + COL_BUFF*sign(speed), direction), obj_car)
if instance_exists(Inst){
	//Damage the vehicle
	hp -= max(abs(other.speed)*3*(other.weight/8) - 1, 0)
	speed = 0
}

///Drop off a delivery
if speed == 0{
	var Order = instance_nearest(x, y, obj_order)
	if instance_exists(Order){
		if distance_to_point(Order.x, Order.y) < 64{
			var has_delivery = ds_list_find_index(picked_up_deliveries, Order.order_id)

			if has_delivery != -1{
				//This order is in the list of picked up deliveries
				/// TODO Player.tips += Order.reward
				obj_menu.Teams[? Player.team].team_score += Order.reward
				ds_list_delete(picked_up_deliveries, has_delivery)
				var Business = ds_map_find_value(global.businesses, get_business_id(Order.order_id))
				Business.popularity++
				instance_destroy(Order)
			}
		}
	}
}


#endregion

if hp > hp_max{
	hp = hp_max
}

// Destroy when too far outside of the room
var margin = 64
if x < -margin or x > room_width + margin or y < -margin or y > room_height + margin{
	hp = 0
}

//Destroy vehicles that are dead, reset them at start
if hp <= 0{
	//Drop any picked up deliveries
	var _size = ds_list_size(picked_up_deliveries)
	for (var i=0; i<_size; i++){
		var Delivery = instance_create_layer(x, y, "lay_instances", obj_delivery)
		Delivery.image_blend = global.business_colors[get_business_id(picked_up_deliveries[| i])]
		Delivery.order_id = picked_up_deliveries[| i]
		Delivery.business_id = Player.team
	}
	ds_list_clear(picked_up_deliveries)

	/// TODO
	//Player.tips -= Player.model_cost[model]
	//if Player.tips < 0 Player.tips = 0
	obj_menu.Teams[? Player.team].team_score -= 100

	instance_create_layer(x, y, "lay_above", obj_explosion)
	x = global.player_start[0]
	y = global.player_start[1]
	hp = hp_max
	direction = 90
	car_dir = 90
	speed = 0
	nitrus = nitrus_max
}

//Cleanup Car Direction
car_dir = (car_dir + 360) mod 360

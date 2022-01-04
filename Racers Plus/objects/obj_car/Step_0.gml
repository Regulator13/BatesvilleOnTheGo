#region Controls
//Accelerate
if keyboard_check(UP_KEY){
	if speed < gear_max_speeds[gear]{
		speed += accel
	}
	else if speed >= gear_max_speeds[gear]{
		current_shift_period += 1
	}
	//Whenever accelerating, reset the reverse shift period
	current_reverse_period = 0
}

//Turning
if keyboard_check(RIGHT_KEY){
	if speed >= min_turn_speed{
		car_dir -= turn_speed*sign(speed)
		//If traveling too fast, lose traction
		if speed > traction*max_speed{	
			direction -= turn_speed*sign(speed)*(1 - (speed - traction*max_speed)/max_speed)	
		}
		else{
			direction -= turn_speed*sign(speed)
		}
	}
	else{
		direction -= speed/min_turn_speed * turn_speed*sign(speed)
		car_dir -= speed/min_turn_speed * turn_speed*sign(speed)
	}
}
if keyboard_check(LEFT_KEY){
	if speed >= min_turn_speed{
		car_dir += turn_speed*sign(speed)
		//If traveling too fast, lose traction
		if speed > traction*max_speed{
			direction += turn_speed*sign(speed)*(1 - (speed - traction*max_speed)/max_speed)
		}
		else{
			direction += turn_speed*sign(speed)
		}
	}
	else{
		direction += speed/min_turn_speed * turn_speed*sign(speed)
		car_dir += speed/min_turn_speed * turn_speed*sign(speed)
	}
}

//Decelerate
if keyboard_check(DOWN_KEY){
	//Brake if not in reverse
	if speed > brake and gear >= 1{
		speed -= brake
	}
	else if gear >= 1{
		speed = 0
	}
	//If the car is already stopped, start to shift to reverse
	if speed <= 0{
		if gear == 0 and speed - accel >= gear_max_speeds[0]{
			speed -= accel
		}
		else{
			current_reverse_period += 1
		}
	}
	//Whenever the brake is touched, reset the shift period
	current_shift_period = 0
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
//Shift the car up if speeding up
if current_shift_period >= shift_period{
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
#endregion

///Collisions with solid walls
if place_meeting(x + lengthdir_x(speed + COL_BUFF*sign(speed), direction), y + lengthdir_y(speed + COL_BUFF*sign(speed), direction), obj_solid){
	//Damage the vehicle
	hp -= max(abs(speed) - 1, 0)
	speed = 0
}

if hp > hp_max{
	hp = hp_max
}

//Destroy vehicles that are dead, reset them at start
if hp <= 0{
	instance_create_layer(x, y, "lay_instances", obj_explosion)
	x = global.player_start[0]
	y = global.player_start[1]
	hp = hp_max
	direction = 90
	car_dir = 90
	speed = 0
}

//Cleanup Car Direction
car_dir = (car_dir + 360) mod 360
#region AI States

stop_dist = ((speed/(brake+fric)) + 1)*(speed/2)
switch(state){
	case DRIVE: //Go forward, accelerating to max speed
		//Accelerate
		if speed < max_speed{
			speed += accel
		}
		//Check for intersections
		//idk what the plus 4 is for I'm sorry
		if place_meeting(x + lengthdir_x(stop_dist+4, direction), y + lengthdir_y(stop_dist+4, direction), par_intersection){
			state = STOP
		}
		break
	
	case STOP: //Stop the car completely at an intersection
		if speed > 0{
			speed = max(speed - brake, 0)
		}
		else if speed == 0{
			state = APPROACH
			speed = approach_speed
		}
		break
		
	case APPROACH: //Approach the middle of the intersection, then stop again
		//Go up to edge of intersection
		if position_meeting(x + lengthdir_x(stop_dist + sprite_height/2 + 1, direction), y + lengthdir_y(stop_dist + sprite_height/2 + 1, direction), par_intersection){
			speed = approach_speed
		}
		else{
			speed = max(speed - brake, 0)
		}
		if speed == 0{
			state = WAIT
			turn_dir = choose_turn_dir()
			////
			show_debug_message(string(turn_dir))
			////
		}
		break
	
	case WAIT: //Wait until the intersection is clear
		var Inst = position_meeting(x + lengthdir_x(sprite_height/2 + BLOCK_SIZE/2, direction), y + lengthdir_y(sprite_height/2 + BLOCK_SIZE/2, direction), obj_intersection_zone)
		with Inst{
			if place_empty(x, y){
				other.state = TURN
			}
		}
		break
		
	case TURN:
		//Go straight
		if turn_dir[0] == STRAIGHT{
			state = DRIVE
		}
		//Make a turn
		else{
			//Find where the turn is
			if turn_state == 0{
				turn_block_x = (x + lengthdir_x(sprite_height/2, direction)) div BLOCK_SIZE + turn_dir[1]
				turn_block_y = (y + lengthdir_y(sprite_height/2, direction)) div BLOCK_SIZE + turn_dir[2]
				starting_dir = direction
				turn_state = 1
				////TO-DO
				if turn_dir[0] = RIGHT_TURN{
					hacky_fix = 4
					if direction > 45 and direction < 135{
						if round(((y + lengthdir_y(sprite_height/2, direction)))/16)*16 mod 32 == 0 hacky_fix = 4
						else hacky_fix = -12
					}
					if direction > 135 and direction < 225{
						if round(((x + lengthdir_x(sprite_height/2, direction)))/16)*16 mod 32 == 0 hacky_fix = 4
						else hacky_fix = -12
					}
					if direction > 225 and direction < 315{
						if round(((y + lengthdir_y(sprite_height/2, direction)))/16)*16 mod 32 == 0 hacky_fix = 4
						else hacky_fix = -12
					}
					if direction > 315 or direction < 45{
						if round(((x + lengthdir_x(sprite_height/2, direction)))/16)*16 mod 32 == 0 hacky_fix = 4
						else hacky_fix = -12
					}
				}
				if turn_dir[0] = LEFT_TURN{
					hacky_fix = 4
					if direction > 45 and direction < 135{
						if round(((y + lengthdir_y(sprite_height/2, direction)))/16)*16 mod 32 == 0 hacky_fix = 4
						else hacky_fix = -12
					}
					if direction > 135 and direction < 225{
						if round(((x + lengthdir_x(sprite_height/2, direction)))/16)*16 mod 32 == 0 hacky_fix = 4
						else hacky_fix = -12
					}
					if direction > 225 and direction < 315{
						if round(((y + lengthdir_y(sprite_height/2, direction)))/16)*16 mod 32 == 0 hacky_fix = 4
						else hacky_fix = -12
					}
					if direction > 315 or direction < 45{
						if round(((x + lengthdir_x(sprite_height/2, direction)))/16)*16 mod 32 == 0 hacky_fix = 4
						else hacky_fix = -12
					}
				}
			}
			//Drive to the turn block
			if turn_state == 1{
				if speed < approach_speed*4{
					speed += accel
				}
				//If going east/west, only the x turn block matters
				var test = lengthdir_x(sprite_height/2 + hacky_fix, direction)
				if (x + lengthdir_x(sprite_height/2 + hacky_fix, direction)) div BLOCK_SIZE == turn_block_x{
					turn_state = 2
				}
				//If going north/south, only the y turn block matters
				if (y + lengthdir_y(sprite_height/2 + hacky_fix, direction)) div BLOCK_SIZE == turn_block_y{
					turn_state = 2
				}
			}
			//Make the turn
			if turn_state == 2{
				if speed < approach_speed{
					speed += accel
				}
				if turn_dir[0] == RIGHT_TURN{
					car_dir -= (speed/(BLOCK_SIZE/2))*90
					direction -= (speed/(BLOCK_SIZE/2))*90
				}
				else if turn_dir[0] == LEFT_TURN{
					car_dir += (speed/(BLOCK_SIZE/2))*90
					direction += (speed/(BLOCK_SIZE/2))*90
				}
				if find_degrees_between(direction, starting_dir) >= 90{
					car_dir = round(direction/90) * 90 //straighten the vehicle
					direction = round(direction/90) * 90 //straighten the vehicle
					state = DRIVE
					turn_state = 0
				}
			}		
		}
		break
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

#endregion

if hp > hp_max{
	hp = hp_max
}

//Destroy vehicles that are dead, reset them at start
if hp <= 0{
	instance_destroy(self)
}

//Cleanup Car Direction
car_dir = (car_dir + 360) mod 360
	
/// @function							choose_turn_dir()
/// @return {int} turn_dir				returns the direction the ai will turn		

function choose_turn_dir(){
	var size = BLOCK_SIZE
	var options = []
	//Check if there is a right turn
	if position_meeting(x + lengthdir_x(size, direction) + lengthdir_x(size, direction - 90), y + lengthdir_y(size, direction) + lengthdir_y(size, direction - 90), obj_exit){
		if direction > 45 and direction < 135 array_push(options, [RIGHT_TURN, 1, -1])
		if direction > 135 and direction < 225 array_push(options, [RIGHT_TURN, -1, -1])
		if direction > 225 and direction < 315 array_push(options, [RIGHT_TURN, -1, 1])
		if direction > 315 or direction < 45 array_push(options, [RIGHT_TURN, 1, 1])
	}
	//Check for straight
	for (var i=1; i<4; i++){
		if position_meeting(x + lengthdir_x(i*size, direction), y + lengthdir_y(i*size, direction), obj_exit){
		array_push(options, [STRAIGHT, 0, i])
		break
		}
	}
	//Check for left
	for (var i=1; i<4; i++){
		for (var j=1; j<4; j++){
			if position_meeting(x + lengthdir_x(i*size, direction) + lengthdir_x(j*size, direction + 90), y + lengthdir_y(i*size, direction) + lengthdir_y(j*size, direction + 90), obj_exit){
				if direction > 45 and direction < 135 array_push(options, [LEFT_TURN, i, -j])
				if direction > 135 and direction < 225 array_push(options, [LEFT_TURN, -i, -j])
				if direction > 225 and direction < 315 array_push(options, [LEFT_TURN, -i, j])
				if direction > 315 or direction < 45 array_push(options, [LEFT_TURN, i, j])
			}
		}
	}
	if array_length(options) == 0{
		return [STRAIGHT, 0, 0]
	}
	return options[irandom(array_length(options) - 1)]
}
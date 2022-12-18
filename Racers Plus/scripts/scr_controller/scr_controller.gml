function get_joystick_input(dir, input){
	var range = 64
	switch input{
		case RIGHT_KEY:
			if dir > 360 - range or dir < 0 + range{
				return KEY_ISPRESSED
			}
			else return KEY_ISRELEASED
		case UP_KEY:
			if dir > 90 - range and dir < 90 + range{
				return KEY_ISPRESSED
			}
			else return KEY_ISRELEASED
		case LEFT_KEY:
			if dir > 180 - range and dir < 180 + range{
				return KEY_ISPRESSED
			}
			else return KEY_ISRELEASED
		case DOWN_KEY:
			if dir > 270 - range and dir < 270 + range{
				return KEY_ISPRESSED
			}
			else return KEY_ISRELEASED
	}
}
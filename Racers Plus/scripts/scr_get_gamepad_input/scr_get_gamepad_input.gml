/// @function scr_get_gamepad_input(key)
/// @description gets the current state of the key
/// @param key | unicode value for the key
/// @param device | device number for checking
/// @ returns real, the constant value state of the key
function scr_get_gamepad_input(argument0, argument1) {

	// set input
	var key = argument0
	var device = argument1

	// return state
	switch(key) {
		case gp_face1:
		case gp_face2:
		case gp_face3:
		case gp_face4:
		case gp_shoulderl: //Left shoulder button
		case gp_shoulderlb: //Left shoulder trigger
		case gp_shoulderr: //Right shoulder button
		case gp_shoulderrb: //Right shoulder trigger
		case gp_select: //The select button (this is the PS button on a DS4 controller)
		case gp_start: //The start button (this is the "options" button on a PS4 controller)
		case gp_stickl: //The left stick pressed (as a button)
		case gp_stickr: //The right stick pressed (as a button)
		case gp_padu: //D-pad up
		case gp_padd: //D-pad down
		case gp_padl: //D-pad left
		case gp_padr: //D-pad rigth
			if (gamepad_button_check_pressed(device, key))
				return (KEY_PRESSED);
			else if (gamepad_button_check(device, key))
				return (KEY_ISPRESSED);
			else if (gamepad_button_check_released(device, key))
			    return (KEY_RELEASED);
			else
			    return (KEY_ISRELEASED);
		case gp_axislh:
		case gp_axislv:
			if gamepad_axis_value(device, key) > GAMEPAD_AXIS_TOL
				return (KEY_PRESSED);
			else
				return (KEY_RELEASED);
		case -gp_axislh:
		case -gp_axislv:
			if gamepad_axis_value(device, -key) < -GAMEPAD_AXIS_TOL
				return (KEY_PRESSED);
			else
				return (KEY_RELEASED);
	}




}

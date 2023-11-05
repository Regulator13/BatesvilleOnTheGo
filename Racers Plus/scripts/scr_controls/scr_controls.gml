// Terms
// Controller - Logical device to game
// Controls - Type of device keyboard, gamepad, mouse
// Control - Left, right, jump, action
// Input - Current state of control, if jump is pressed or not
// Key - Button, key, trigger, constant on the device

// Input states
#macro INPUT_PRESSED 2
#macro INPUT_ISPRESSED 1
#macro INPUT_ISRELEASED 0
#macro INPUT_RELEASED -1

#macro GAMEPAD_AXIS_TOL .7

#macro DEVICE_GAMEPAD 0
// Up to 4 XInput pads and another 8 DirectInput pads
#macro DEVICE_KEYBOARD 12
#macro DEVICE_MOUSE 13

#macro MOUSE_X_AXIS 0
#macro MOUSE_Y_AXIS 1

function controls_declare_functions() {
	save_controllers = function() {
		var data = json_stringify(controllers, true)
		var file = file_text_open_write("controllers.json")
		file_text_write_string(file, data)
		file_text_close(file)
	}
	
	load_controllers = function() {
		var data = file_read_all_text("controllers.json")
		var controller_data = json_parse(data)
		array_foreach(controller_data, load_controller)
	}
	
	load_controller = function(controller, index){
		controllers[index] = new stc_controller(index)
		for (var i=0; i<array_length(controller.controls); i++) {
			var control = controller.controls[i]
			if control != pointer_null {
				switch control.struct_name {
					case "control":
						controllers[index].controls[i] = new stc_control(control.device, control.constant)
						break
					case "position_contol":
						controllers[index].controls[i] = new stc_position_control(control.device, control.constant)
						break
				}
			}
			else {
				controllers[index].controls[i] = pointer_null
			}
		}
	}
}

function controls_toggle_input(old_state, new_state) {
	if (old_state == INPUT_PRESSED or old_state == INPUT_ISPRESSED) and new_state == INPUT_PRESSED {
		return INPUT_ISPRESSED
	}
	if (old_state == INPUT_RELEASED or old_state == INPUT_ISRELEASED) and new_state == INPUT_RELEASED {
		return INPUT_ISRELEASED
	}
	else {
		return new_state
	}
}

/// @function  get_key_input(key)
/// @description Gets the current state of the key
/// @param  key
//  Return real, the state of the key
function get_key_input(key){
	if (keyboard_check_pressed(key))
	    return (INPUT_PRESSED)
	else if (keyboard_check(key))
	    return (INPUT_ISPRESSED)
	else if (keyboard_check_released(key))
	    return (INPUT_RELEASED)
	else
	    return (INPUT_ISRELEASED)
}

/// @description scr_get_mouse_input(button)
/// @description Gets the current state of the button
/// @param  button
//  Return real, the state of the button
function get_mouse_input(button) {
	if (device_mouse_check_button_pressed(0, button))
	    return (INPUT_PRESSED)
	else if (device_mouse_check_button(0, button))
	    return (INPUT_ISPRESSED)
	else if (device_mouse_check_button_released(0, button))
	    return (INPUT_RELEASED)
	else
	    return (INPUT_ISRELEASED)
}

function get_mouse_position_input(axis) {
	if axis == MOUSE_X_AXIS
		return window_view_mouse_get_x(0)
	else if axis = MOUSE_Y_AXIS
		return window_view_mouse_get_y(0)
}

/// @function  get_gamepad_input(key)
/// @description  Gets the current state of the key
/// @param  key | unicode value for the key
/// @param  device | device number for checking
//  Returns real, the constant value state of the key
function get_gamepad_input(key, device){
	switch(key) {
		case gp_face1:
		case gp_face2:
		case gp_face3:
		case gp_face4:
		case gp_shoulderl:  // Left shoulder button
		case gp_shoulderlb: // Left shoulder trigger
		case gp_shoulderr:  // Right shoulder button
		case gp_shoulderrb: // Right shoulder trigger
		case gp_select: // The select button (this is the PS button on a DS4 controller)
		case gp_start:  // The start button (this is the "options" button on a PS4 controller)
		case gp_stickl: // The left stick pressed (as a button)
		case gp_stickr: // The right stick pressed (as a button)
		case gp_padu: // D-pad up
		case gp_padd: // D-pad down
		case gp_padl: // D-pad left
		case gp_padr: // D-pad rigth
			if (gamepad_button_check_pressed(device, key))
				return (INPUT_PRESSED)
			else if (gamepad_button_check(device, key))
				return (INPUT_ISPRESSED)
			else if (gamepad_button_check_released(device, key))
			    return (INPUT_RELEASED)
			else
			    return (INPUT_ISRELEASED)
		case gp_axislh:
		case gp_axislv:
		case gp_axisrh:
		case gp_axisrv:
			if gamepad_axis_value(device, key) > GAMEPAD_AXIS_TOL
				return (INPUT_PRESSED)
			else
				return (INPUT_RELEASED)
		case -gp_axislh:
		case -gp_axislv:
		case -gp_axisrh:
		case -gp_axisrv:
			if gamepad_axis_value(device, -key) < -GAMEPAD_AXIS_TOL
				return (INPUT_PRESSED)
			else
				return (INPUT_RELEASED)
	}
}

function get_gamepad_position_input(axis, device) {
	return gamepad_axis_value(device, axis)
}
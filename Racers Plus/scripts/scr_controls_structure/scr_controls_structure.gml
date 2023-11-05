function stc_controller(index) constructor {
	// stc_control
	controls = array_create(0)
	
	// Created and not loaded, so set default controls
	controller_type = controls_set_default_controls(controls, index)
	
	update_input_states = function() {
		array_foreach(controls, function(_element, _index) {
				if _element != pointer_null {
					_element.update_input_state()
				}
				})
	}
	clear_input_states = function() {
		array_foreach(controls, function(_element, _index) {
				if _element != pointer_null {
					_element.clear_input_state()
				}
				})
	}
	get_input = function(control) {
		var input_state = controls[control].input_state
		return input_state
	}
	get_constant_name = function(control) {
		return controls[control].get_constant_name()
	}
	get_type = function() {
		return controller_type
	}
	get_device = function(control) {
		return controls[control].device
	}
	get_constant = function(control) {
		return	controls[control].constant
	}
	set_constant = function(control, constant) {
		controls[control].constant = constant
	}
	
	get_name = function() {
		controls_get_control_name(device)
	}
}

function stc_control(_device, _constant) constructor {
	device = _device
	constant = _constant
	input_state = INPUT_ISRELEASED
	struct_name = "control"
	
	update_input_state = function() {
		switch device {
			case DEVICE_KEYBOARD:
				input_state = get_key_input(constant)
				break
			case DEVICE_MOUSE:
				input_state = get_mouse_input(constant)
				break
			default:
				// 0-11 reserved for gamepads
				var new_state = get_gamepad_input(constant, device)
				switch constant {
					case gp_axislh:
					case gp_axislv:
					case -gp_axislh:
					case -gp_axislv:
					case gp_axisrh:
					case gp_axisrv:
					case -gp_axisrh:
					case -gp_axisrv:
						input_state = controls_toggle_input(input_state, new_state)
						break
					default:
						input_state = new_state
						break
				}	
				break
		}
	}
	clear_input_state = function() {
		input_state = INPUT_ISRELEASED
	}
	
	get_constant_name = function() {
		switch device {
			case DEVICE_KEYBOARD:
				return controls_get_keyboard_name(constant)
			case DEVICE_MOUSE:
				return controls_get_mouse_name(constant)
			default:
				// 0-11 reserved for gamepads
				return controls_get_gamepad_name(constant)
		}
	}
}

function stc_position_control(_device, _constant) : stc_control(_device, _constant) constructor {
	struct_name = "position_control"
	
	update_input_state = function() {
		switch device {
			case DEVICE_KEYBOARD:
				
				break
			case DEVICE_MOUSE:
				input_state = get_mouse_position_input(constant)
				break
			default:
				// 0-11 reserved for gamepads
				input_state = get_gamepad_position_input(constant, device)
				break
		}
	}
}
function controls_get_device_name(device){
	switch device {
		case DEVICE_KEYBOARD:
			return return "Keyboard"
		case DEVICE_MOUSE:
			return return "Keyboard+Mouse"
		default:
			// 0-11 reserved for gamepads
			return return string_ext("Gamepad {0}", device)
	}
}

/// @description controls_get_keyboard_name(key)
/// @param key
function controls_get_keyboard_name(key) {
	if (key > 47 and key < 40 or key > 64 and key < 91) {// or key > 96 and key < 123) {
	    return chr(key)
	    }
	else {
	    switch (key) {
	        case 32:
	            return "space"
	        case 58:
	            return ":"
	        case 59:
	            return ""
	        case 60:
	            return "<"
	        case 62:
	            return ">"
	        case 63:
	            return "\\"
	        case vk_left:
	            return "left"
	        case vk_right:
	            return "right"
	        case vk_up:
	            return "up"
	        case vk_down:
	            return "down"
	        case vk_enter:
	            return "enter"
	        case vk_numpad0:
	            return "num 0"
	        case vk_numpad1:
	            return "num 1"
	        case vk_numpad2:
	            return "num 2"
	        case vk_numpad3:
	            return "num 3"
			case vk_numpad4:
				return "num 4"
			case vk_numpad5:
				return "num 5"
			case vk_numpad6:
				return "num 6"
	        default:
	            return "Error! " + string(key)
	    }
	}
}

/// @description controls_get_mouse_name(key)
/// @param key
function controls_get_mouse_name(key) {
	// get name
	switch (key) {
	    case mb_left:
	        return "mouse left"
	    case mb_right:
	        return "mouse right"
	    case mb_middle:
	        return "mouse middle"
	    default:
	        return "Error! " + string(key)
	}
}


/// @function controls_get_gamepad_name(key)
/// @description Takes key and returns its name
/// @param key
function controls_get_gamepad_name(key) {
	switch key {
	    case gp_face1:
	        return "A"
	    case gp_face2:
	        return "B"
	    case gp_face3:
	        return "X"
	    case gp_face4:
	        return "Y"
		case gp_shoulderl:
			return "Left shoulder button"
		case gp_shoulderlb:
			return "Left shoulder trigger"
		case gp_shoulderr:
			return "Right shoulder button"
		case gp_shoulderrb:
			return "Right shoulder trigger"
		case gp_select:
			return "Select"
		case gp_start:
			return "Start"
		case gp_stickl:
			return "The left stick pressed (as a button)"
		case gp_stickr:
			return "The right stick pressed (as a button)"
		case gp_padu:
			return "D-pad up"
		case gp_padd:
			return "D-pad down"
		case gp_padl:
			return "D-pad left"
		case gp_padr:
			return "D-pad right"
		case gp_axislh:
			return "Left stick Right"
		case -gp_axislh:
			return "Left stick Left"
		case gp_axislv:
			return "Left stick Down"
		case -gp_axislv:
			return "Left stick Up"
		case gp_axisrh:
			return "Right stick Right"
		case -gp_axisrh:
			return "Right stick Left"
		case gp_axisrv:
			return "Right stick Down"
		case -gp_axisrv:
			return "Right stick Up"
	    default:
	        return "Error! " + string(key)
	}
}



#macro LEFT_INPUT 0
#macro RIGHT_INPUT 1
#macro UP_INPUT 2
#macro DOWN_INPUT 3
// Controls before this are not sent over networks
#macro ACTION_INPUT 4

function controls_declare_interface_functions() {
	#region Menu
	state_switch = function(from, to){
		array_foreach(controllers, function(_element, _index){
			_element.clear_input_states()	
			})
	}
	#endregion
	
	set_default_controllers = function() {
		// stc_controller
		controllers = array_create_ext(8, function(index){return new stc_controller(index)})
	}
	
	get_control_name = function(control) {
		switch (control) {
		    case LEFT_INPUT:
		        return "Left"
		    case RIGHT_INPUT:
		        return "Right"
		    case UP_INPUT:
		        return "Up"
		    case DOWN_INPUT:
		        return "Down"
		    case ACTION_INPUT:
		        return "Action"
		    default:
		        return "Error! " + string(control)
		}
	}
}

function controls_set_default_controls(controls, index) {
	// Cannot be a function of obj_controls since obj_controls Create event calls it
	switch(index) {
		case 0:
		case 1:
		case 2:
		case 3:
			controls[LEFT_INPUT] =			new stc_control(index, -gp_axislh)
		    controls[RIGHT_INPUT] =			new stc_control(index, gp_axislh)
		    controls[UP_INPUT] =			new stc_control(index, -gp_axislv)
		    controls[DOWN_INPUT] =			new stc_control(index, gp_axislv)
		    controls[ACTION_INPUT] =		new stc_control(index, gp_face1)
			return index
		case 4:
			controls[LEFT_INPUT] =			new stc_control(DEVICE_KEYBOARD, vk_left)
		    controls[RIGHT_INPUT] =			new stc_control(DEVICE_KEYBOARD, vk_right)
		    controls[UP_INPUT] =			new stc_control(DEVICE_KEYBOARD, vk_up)
		    controls[DOWN_INPUT] =			new stc_control(DEVICE_KEYBOARD, vk_down)
		    controls[ACTION_INPUT] =		new stc_control(DEVICE_KEYBOARD, vk_numpad0)
			return DEVICE_KEYBOARD
		case 5:
			controls[LEFT_INPUT] =			new stc_control(DEVICE_KEYBOARD, ord("A"))
		    controls[RIGHT_INPUT] =			new stc_control(DEVICE_KEYBOARD, ord("D"))
		    controls[UP_INPUT] =			new stc_control(DEVICE_KEYBOARD, ord("W"))
		    controls[DOWN_INPUT] =			new stc_control(DEVICE_KEYBOARD, ord("S"))
		    controls[ACTION_INPUT] =		new stc_control(DEVICE_KEYBOARD, vk_space)
			return DEVICE_MOUSE
		case 6:
			controls[LEFT_INPUT] =			new stc_control(DEVICE_KEYBOARD, ord("Z"))
		    controls[RIGHT_INPUT] =			new stc_control(DEVICE_KEYBOARD, ord("V"))
		    controls[UP_INPUT] =			new stc_control(DEVICE_KEYBOARD, ord("C"))
		    controls[DOWN_INPUT] =			new stc_control(DEVICE_KEYBOARD, ord("X"))
		    controls[ACTION_INPUT] =		new stc_control(DEVICE_KEYBOARD, vk_space)
			return DEVICE_KEYBOARD
		case 7:
			controls[LEFT_INPUT] =			new stc_control(DEVICE_KEYBOARD, ord("T"))
		    controls[RIGHT_INPUT] =			new stc_control(DEVICE_KEYBOARD, ord("H"))
		    controls[UP_INPUT] =			new stc_control(DEVICE_KEYBOARD, ord("I"))
		    controls[DOWN_INPUT] =			new stc_control(DEVICE_KEYBOARD, ord("J"))
		    controls[ACTION_INPUT] =		new stc_control(DEVICE_KEYBOARD, vk_space)
			return DEVICE_KEYBOARD
		default:
			show_error("Error! Default controller setup not defined.", true)
	}
}
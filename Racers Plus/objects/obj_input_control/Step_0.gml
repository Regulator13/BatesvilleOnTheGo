/// @description Input
// escape
if (keyboard_check(vk_escape)) {
    instance_destroy()
	exit
}

switch controller.get_device(control) {
    case DEVICE_KEYBOARD:
        // check for keyboard input
        if (keyboard_key) {
            controller.set_constant(control, keyboard_key)
            instance_destroy()
        }
        break
    case DEVICE_MOUSE:
        if (device_mouse_check_button(0, mb_left)) {
            controller.set_constant(control, mb_left)
            instance_destroy()
        }
			
        else if (device_mouse_check_button(0, mb_right)) {
            controller.set_constant(control, mb_right)
            instance_destroy()
        }
			
        else if (device_mouse_check_button(0, mb_middle)) {
            controller.set_constant(control, mb_middle)
            instance_destroy()
        }
        break
	default:
        //check for button presses
		for (var i = gp_face1; i <= gp_padr; i++) {
			if (gamepad_button_check_pressed(controller.get_type(), i)) {
				controller.set_constant(control, i)
				instance_destroy()
			}
        }
		//check left axis
		for (i = 0; i < array_length(axis_controls); i++) {
			if get_gamepad_input(axis_controls[i], controller.get_type()) {
				controller.set_constant(control, axis_controls[i])
				instance_destroy()
			}
        }
        break
}
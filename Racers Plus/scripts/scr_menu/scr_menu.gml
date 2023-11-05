function menu_declare_functions() {
	menu_create_control_button = function(_x, _y, controller, control) {
		var Button = instance_create_layer(_x, _y, "lay_instances", obj_control_button)
		Button.controller = controller
	    Button.control = control
	    Button.title = obj_controls.get_control_name(control) + ": "
	    ds_list_add(buttons, Button)
	}
}
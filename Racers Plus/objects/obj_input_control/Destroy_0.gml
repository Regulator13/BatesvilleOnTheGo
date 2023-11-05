/// @description Clear all input
Source.title = obj_controls.get_control_name(control) + ": "
io_clear()
// Clear input, but gamepad buttons still show as pressed
array_foreach(obj_controls.controllers, function(_element, _index){
			_element.clear_input_states()	
			})
obj_control_button.alarm[0] = 10
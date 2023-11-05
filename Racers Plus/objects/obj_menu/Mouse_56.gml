/// @description Input box selection

//TODO: cleanup
continue_input_checking = true

// Give currently selected button first shot
// Necessary in the case of dropdown menus
var Input_box = Buttons[| selected_button_index]
if not is_undefined(Input_box) and instance_exists(Input_box) {
	with Input_box event_user(1)
}

var _count = instance_number(obj_input_box)
for (var i=0; i<_count; i++){
	var Input_box = instance_find(obj_input_box, i)
	if Input_box.selected = true{
		with Input_box {
			event_user(1)
		}
		if not continue_input_checking break
	}
}
if continue_input_checking{
	for (var i=0; i<_count; i++){
		var Input_box = instance_find(obj_input_box, i)
		with Input_box {
			event_user(1)
		}
		if not continue_input_checking break
	}
}
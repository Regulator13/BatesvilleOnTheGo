/// @description Input box selection
//TODO: cleanup
continue_input_checking = true
var _count = instance_number(obj_input_box)
for (var i=0; i<_count; i++){
	var Input_box = instance_find(obj_input_box, i)
	if Input_box.selected == true{
		with Input_box{
			event_user(1)
		}
		if not continue_input_checking break
	}
}
if continue_input_checking{
	for (var i=0; i<_count; i++){
		var Input_box = instance_find(obj_input_box, i)
		with Input_box{
			event_user(1)
		}
		if not continue_input_checking break
	}
}

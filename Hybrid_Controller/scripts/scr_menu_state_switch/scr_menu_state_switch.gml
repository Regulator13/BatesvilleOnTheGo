/// @function  menu_state_switch(from, to)
/// @descrption  Switches the current menu state to the new state
/// @param  from
/// @param  to
function menu_state_switch(from, to) {
	// switch menu state
	with (obj_menu) {
		//check if going back one state
		if ds_stack_top(state_queue) = to
			ds_stack_pop(state_queue)//delete last entry
		else
			ds_stack_push(state_queue, from)//add new entry

		//set state
		state = to

		//switch state
	}
}

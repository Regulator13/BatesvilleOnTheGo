/// @description Input

#region Menu Controls
if not instance_exists(obj_input_message){
	var haxis = 0
	var vaxis = 0
	var action = false
		
	for (var i=0; i<array_length(obj_controls.controllers); i++) {
		var controller = obj_controls.controllers[i]
		if (controller.get_input(LEFT_INPUT) == INPUT_PRESSED) haxis = -1
		if (controller.get_input(RIGHT_INPUT) == INPUT_PRESSED) haxis = 1
		if (controller.get_input(UP_INPUT) == INPUT_PRESSED) vaxis = -1
		if (controller.get_input(DOWN_INPUT) == INPUT_PRESSED) vaxis = 1
		if (controller.get_input(ACTION_INPUT) == INPUT_PRESSED) {
			action = true
			main_player_controller = i
		}
	}
	
	switch(state){
        case STATE_GAME:
			// No menu
            break
		default:
			#region Default
			if ds_list_size(Buttons) > 0 {
                //Button controls
                var Button = Buttons[| selected_button_index]
                
                if Button.allow_scroll{
		            // Scroll through available Buttons
					var scroll = haxis + vaxis
					// If on a value Button limit scroll to only down and up
					// to allow left and right to change value
		            if (!is_undefined(Button)){
		                if (instance_exists(Button) and (Button.action == VALUE_BUTTON or Button.action == VALUEACTION_BUTTON)){
		                    scroll -= haxis
						}
					}
					selected_button_index = scr_increment_in_bounds(selected_button_index, scroll, 0, ds_list_size(Buttons)-1, true)
				}
				// Interact with selected Button
	            if instance_exists(Button){
					// Change value in value Buttons
	                if (Button.action == VALUE_BUTTON) {
	                    Button.value = scr_increment_in_bounds(Button.value, haxis, 0, ds_list_size(Button.values)-1, true)
	                }
	                else if (Button.action == VALUEACTION_BUTTON) {
	                    Button.value = scr_increment_in_bounds(Button.value, haxis, 0, ds_list_size(Button.values)-1, true)
	                    // If value changed do action
	                    if (haxis != 0)
	                        with (Button) event_user(0)
	                }
					// Press Button
	                if (action)
	                    with (Button) event_user(0)
	            }
			}
			#endregion
			break
	}
}
#endregion

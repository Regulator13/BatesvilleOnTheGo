/// @description Input
inputs[LEFT_KEY] = get_key_input(global.controls[controls, LEFT_KEY]);
inputs[RIGHT_KEY] = get_key_input(global.controls[controls, RIGHT_KEY]);
inputs[UP_KEY] = get_key_input(global.controls[controls, UP_KEY]);
inputs[DOWN_KEY] = get_key_input(global.controls[controls, DOWN_KEY]);
inputs[ACTION_KEY] = get_key_input(global.controls[controls, ACTION_KEY]);

///CHEATS
//Go to next car model
if controls == 1{
	if keyboard_check_pressed(ord("Q")){
		instance_destroy(Car)
		model++
		if model > 8 model = 0
		tips -= model_cost[model]
		event_user(0)
	}
}
if controls == 0{
	if keyboard_check_pressed(vk_numpad1){
	instance_destroy(Car)
	model++
	if model > 8 model = 0
	tips -= model_cost[model]
	event_user(0)
	}
}
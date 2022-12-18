/// @description Click
if active{
	if point_in_rectangle(mouse_x, mouse_y, x, y, x + box_height, y + box_height){
		event_user(0)
		obj_menu.continue_input_checking = false
	}
}

/// @description Click button
if point_in_rectangle(mouse_x, mouse_y, x, y, x + box_width, y + box_height){
	obj_menu.continue_input_checking = false
	event_user(0)
}
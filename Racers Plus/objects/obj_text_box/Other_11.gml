/// @description Mouse selection
// Called by obj_meny global left mouse release
if active{
	if point_in_rectangle(mouse_x, mouse_y, x, y, x + max_text_width + 2*edge, y + max_text_height + 2*edge){
		// Select
		select()
	}
	else{
		// Deselect
		if selected event_user(0)
	}
}

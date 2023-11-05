/// @description scr_menu_clear()
function scr_menu_clear() {
	/*
	/ Description: clears the preivous menu
	/ Parameters : none
	/ Return     : void
	*/

	//clear buttons
	var _length = ds_list_size(Buttons)
	repeat(_length) {
	    instance_destroy(ds_list_find_value(Buttons, 0))
	}
	
	// reset selected
	selected_button_index = 0

}

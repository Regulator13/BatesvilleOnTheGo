/// @description Initialize menu
if os_browser == browser_not_a_browser{
	//show_error("Warning! Hybrid menu only works on HTML5", true)
}

//display_set_gui_size(display_get_width(), display_get_height())
html_init()
width = 0
height = 0

// Initialize online state
instance_create_layer(0, 0, "lay_instances", obj_hybrid_online)
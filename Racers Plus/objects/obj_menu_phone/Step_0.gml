/// @description Input
#region Browser
if os_browser != browser_not_a_browser{
	if (browser_width != width || browser_height != height){
		show_debug_message("Resize screen to browser!")
	    width = browser_width
	    height = browser_height
	    window_set_size(width, height)
		view_wport[0] = window_get_width()
		view_hport[0] = window_get_height()
		surface_resize(application_surface, view_wport[0], view_hport[0])
	}
}
#endregion

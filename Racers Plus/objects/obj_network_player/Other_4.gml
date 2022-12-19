/// @description Post-initialization setup
if room != mnu_main and room != mnu_lobby and room != mnu_score{
	//get unique player colour based on join order
	show_debug_message("obj_player connect_id: " + string(connect_id) + scr_colour_string(connect_id))
}
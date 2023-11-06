/// @description Create car if not online
if not global.online or global.have_server{
	if obj_menu.state == STATE_GAME and os_browser == browser_not_a_browser{
		//Create vehicle
		event_user(0)
	}
}
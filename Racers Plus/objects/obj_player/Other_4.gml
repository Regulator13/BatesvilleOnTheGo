/// @description Create car if not online
if not global.online or global.have_server{
	if obj_menu.state == STATE_GAME{
		//Create vehicle
		event_user(0)
	}
}
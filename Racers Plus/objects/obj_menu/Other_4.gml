/// @description Initiate rooms!

//reset keyboard input for button selection
keyboard_input = false

if os_browser == browser_not_a_browser{
	switch global.Menu.state{
		case STATE_ONLINE:
			#region Online
			//Create buttons
			var _y = room_height - 112
			ds_list_add(Buttons, scr_create_button(96, _y, noone, "host"))
			ds_list_add(Buttons, scr_create_button(300, _y, noone, "direct"))
			ds_list_add(Buttons, scr_create_button(1094, _y, noone, "quit"))
			#endregion
			break
		case STATE_LOBBY:
			#region Lobby
			ds_list_add(Buttons, scr_create_button(96, 675, noone, "ready"))
			ds_list_add(Buttons, scr_create_button(room_width - 256, 675, noone, "back"))
			#endregion
			break
		case STATE_SCORE:
			#region Score
			var _y = room_height - 112
			ds_list_add(Buttons, scr_create_button(96, 675, noone, "ready"))
			ds_list_add(Buttons, scr_create_button(1094, _y, noone, "quit"))
			#endregion
			break
	}
}
else{
	switch global.Menu.state{
		case STATE_SCORE:
			#region Score
			var _x = 64
			var _y = room_height - 64
			ds_list_add(Buttons, scr_create_button(_x, _y - 64, noone, "ready"))
			#endregion
	}
}
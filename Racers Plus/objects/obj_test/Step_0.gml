/// @description Next state
switch obj_menu.state{
	case STATE_MAIN:
		if not ready_up[4]{
			with obj_menu.Buttons[| 0]{
				event_user(0)
			}
			ready_up[4] = true
		}
		break
	case STATE_ONLINE:
		if not ready_up[5]{
			// Host
			with obj_online event_user(1)
			ready_up[5] = true
		}
		break
}


/// @description Insert description here
if os_browser != browser_not_a_browser{
	instance_destroy()
}
// Trigger if a ready up message has been sent
ready_up[5] = false
ready_up[4] = false
ready_up[STATE_LOBBY] = false
ready_up[STATE_GAME] = false
ready_up[STATE_SCORE] = false

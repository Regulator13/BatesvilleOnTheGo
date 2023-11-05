/// @description Insert description here
if os_browser != browser_not_a_browser{
	instance_destroy()
}

var disable = false
// Trigger if a ready up message has been sent
ready_up[5] = disable
ready_up[4] = disable
ready_up[STATE_LOBBY] = true
ready_up[STATE_GAMECONFIG] = disable
ready_up[STATE_GAME] = disable
ready_up[STATE_SCORE] = disable

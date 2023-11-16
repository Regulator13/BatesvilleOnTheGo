/// @description Periodically update server when driving
if state == STATE_DRIVING {
	request_action(ACT_GAME_DRIVE_UPDATE, throttle, steer)
}
alarm[0] = drive_update_wait_steps
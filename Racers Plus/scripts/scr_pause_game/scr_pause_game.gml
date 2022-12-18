/// @function scr_pause_game()
/// @description Carry out actions to pause a networking game
//  Returns null
function scr_pause_game() {
	//actual pausing code in End Step of obj_client
	//since pausing and unpausing must occur at the same place
	//to ensure nothing gets out of sync
	obj_client.pause = true
}

/// @function scr_unpause_game()
/// @description Carry out actions to unpause a networking game
//  Returns null
function scr_unpause_game() {
	//actual pausing code in End Step of obj_client
	//since pausing and unpausing must occur at the same place
	//to ensure nothing gets out of sync
	obj_client.unpause = true
}

/// @function scr_pause_game_during_communication_turn_end()
/// @description Extra precautions must be taken to pause the game during the end of a communication turn else a step will be skipped
//  Returns null
function scr_pause_game_during_communication_turn_end(){
	obj_client.pause = true
	//must reduce one from obj_client's game_step counter because
	//obj_client will pause the game directly after adjusting the timer,
	//and when it unpauses it will increment the timer again
	//without actually completing a step
	obj_client.pause_during_communication_turn_end = true
}
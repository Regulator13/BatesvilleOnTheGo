/// @description Reset game_step counter
game_step = 0

//record how long each turn takes in mircroseconds
//this first measurment will be off since turn_start is not set right next to actual_turn_speed
turn_start = get_timer()
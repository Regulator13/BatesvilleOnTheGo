#macro STATE_GAME_OPTIONS -6
#macro STATE_ONLINE -5
#macro STATE_CONTROLS -4
#macro STATE_DEBUGOPTIONS -3
#macro STATE_OPTIONS -2
#macro STATE_MAIN -1
// All states that are accesible while networked, need to be non-negative
// as the system uses an unsigned integer to send them
#macro STATE_LOBBY 0
#macro STATE_GAMECONFIG 1
#macro STATE_GAME 2
#macro STATE_SCORE 3

// Button actions cannot overlap menu states
// as these are also possible actions
#macro VALUE_BUTTON 10
#macro VALUEACTION_BUTTON 11
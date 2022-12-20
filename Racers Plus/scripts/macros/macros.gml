
#macro BLOCK_SIZE 32

//AI macros
#macro DRIVE 0
#macro DECELERATE 1
#macro APPROACH 2
#macro STOP 3
#macro WAIT 4
#macro TURN 5
#macro PARK 6

//AI turn_dir
#macro LEFT_TURN 0
#macro RIGHT_TURN 1
#macro STRAIGHT 2

//Room Creation Macros

// Controller states
#macro STATE_DRIVING 0
#macro STATE_PICKING_UP 1

//Grid size for map
#macro GRID_SIZE 32

#macro TEAM_BLOCK_AMOUNT 30
#macro MIN_BLOCK_AMOUNT 4

//Number of iterations of map generator (Creates a room of size 2*N + 1)
#macro ITERATION_NUMBER 7

//Set a value to be rounded in with total from -weight to +weight
#macro RAND_WEIGHT 8

#macro TRY_MAX 100 //The max number of tries a conditional random event (e.g. spawning) will attempt

#macro LANDMARK_FREQUENCY 10 //Set the number of landmarks per 128X128 map size (X4 for +1 to ITERATION)
#macro FOOD_FREQUENCY 15 //Set the number of foodstuffs per 128X128 map size (X4 for +1 to ITERATION)
#macro ANIMAL_FREQUENCY 20 //Set the number of animals per 128X128 map size (X4 for +1 to ITERATION)

//Terrain Constants
#macro TOP_WATER_LEVEL 1
#macro TOP_GRASS_LEVEL 6
#macro TOP_MOUNTAIN_LEVEL 10
#macro TREE_MIN 8 //The fraction of the map that is NOT trees out of MAX_HEIGHT

//Energy Cost Constants
#macro COST_BASE 10 //Base energy lost for each movement
#macro COST_GRASS_CLIMB 10 //Extra energy spent when climbing to a grass level
#macro COST_MOUNTAIN_CLIMB 20 //Extra energy spent when climbing in a mountain
#macro COST_SHOUTING 50 //Energy cost to shout
#macro COST_MAX_BASE .2 //The amount of max energy lost per movement
#macro COST_MAX_GRASS_CLIMB .3 //The amount of max energy lost when climbing to a grass level
#macro COST_MAX_MOUNTAIN_CLIMB .6 //The amount of max energy lost when climbing a mountain
#macro COST_ATTACK 15 //The amount of energy lost when attacking an animal

//Animal State Constants
#macro WANDERING 0 //Animal sees and hears nothing
#macro ALERT 1 //Animal hears something
#macro FOLLOWING 2 //Animal hears/sees something and wants to find it
#macro AVOIDING 3 //Animal hears/sees something and wants to get away from it
#macro CHARGING 4 //Animal is close to something and wants to attack it
#macro FLEEING 5 //Animal is close to something and watns to get away from it

//Set a min and max height value
#macro MIN_HEIGHT 0
#macro MAX_HEIGHT 10

#macro BROADCAST_RATE 60

#macro GAME_ID 1

#macro MINIMUM_TURN_LENGTH 4
#macro IDEAL_FPS 60

#macro LAY_BELOW "lay_instances_below"
#macro LAY "lay_instances"

#macro TCP_PORT 6513
#macro UDP_PORT 6510
#macro BROADCAST_PORT 6511

//client side network states
#macro NETWORK_TCP_CONNECT 0
#macro NETWORK_UDP_CONNECT 4
#macro NETWORK_LOGIN 2
#macro NETWORK_LOBBY 3
//reserved for communicatin turn dictated play
#macro NETWORK_PLAY 1
#macro NETWORK_SCORE 5


#macro CLIENT_CONNECT 5
#macro CLIENT_LOGIN 3
#macro CLIENT_PLAY 0
#macro CLIENT_PING 7
#macro CLIENT_WAIT 9
#macro CLIENT_PERFORMANCE 11
//numbers cannot duplicate client messages, because client-server cannot differentiate via ports
#macro SERVER_CONNECT 6
#macro SERVER_LOGIN 4
#macro SERVER_PLAY 2
#macro SERVER_PING 8
#macro SERVER_STATESWITCH 10
#macro SERVER_TURN 12

#macro INPUT_CMD 0
#macro STRING_CMD 10
#macro PICKUP_CMD 20
#macro UPDATE_CMD 30

#macro DEFAULT_SECTION 0
#macro SPAWN_SECTION 1
#macro NETWORK_SECTION 2

#region Control mapping
#macro SEQUENCE_MAX 255
#macro CONTROLS_KEYBOARD 5
#macro CONTROLS_MOUSE 6
#macro CONTROLS_GP1 0
#macro CONTROLS_GP2 1
#macro CONTROLS_GP3 2
#macro CONTROLS_GP4 3
#macro CONTROLS_GP5 4
#macro GAMEPAD_AXIS_TOL .5
#endregion

#region Menu states
#macro STATE_GAME_OPTIONS -6
#macro STATE_ONLINE -5
#macro STATE_CONTROLS -4
#macro STATE_DEBUGOPTIONS -3
#macro STATE_OPTIONS -2
#macro STATE_MAIN -1
#macro STATE_LOBBY 0
#macro STATE_PATHS 1
#macro STATE_GAME 2
#macro STATE_SCORE 3
#endregion

#region All possible game commands
#macro MOVE_PLACE 0
#macro ACTION 4

#macro NAME_CHANGE 40
#macro COLOR_CHANGE 41
#macro TEAM_CHANGE 42
#macro SECTION_CHANGE 43
#macro MAP_CHANGE 44
#macro READY_UP 45
#macro SELECT_START 46
#macro SELECT_STOP 47
#macro PLAYER_COLOR_CHANGE 48

//Reserve 10 numbers
#macro CALL 50

//when adding input macros do not forget max input check in obj_player
#endregion

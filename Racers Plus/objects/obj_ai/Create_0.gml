/// @description Initialize Vehicle Variables

direction = 90 //Direction the car is actually traveling. Start facing up
car_dir = 90 //Direction the car is facing
fric = .005 //Friction the car is currently experiencing
turn_speed = 2 //How many degrees the car turns each step
min_turn_speed = 1 //Slowest the car can be traveling and still turn full speed
accel = .01 //How fast the car speeds up
brake = .02 //How fast the car slows down
max_speed = 1.5 //The fastest the car can go
traction = .6 //Portion of max speed the vehicle can travel without losing traction
retraction_rate = 1 //The number of degrees the vehicle's direction realigns with its orientation per step
hp_max = 60 //Vehicle's maximum health
weight = 3 //How much the car weighs

hp = hp_max //Vehicles's current health

Player = noone
model = -1

//AI Variables
state = DRIVE
stop_dist = 0 //The minimum distance required to stop the vehicle in pixels
approach_speed = max_speed/5
turn_dir = [-1, 0, 0] //[Direction, # of blocks to the left/right, # of blocks straight] for turns
starting_dir = 0 //The car's direction before the turn
turn_state = 0 //0 = set turn location, 1 = move forward, 2 = turn
turn_block_x = 0 //What x block the turn is (BLOCK_SIZE blocks)
turn_block_y = 0 //What y block the turn is (BLOCK_SIZE blocks)
hacky_fix = 0 //some garbage fix

picked_up_deliveries = ds_list_create()

/// @description Initialize Vehicle Variables

direction = 90 //Direction the car is actually traveling. Start facing up
car_dir = 90 //Direction the car is facing
fric = .05 //Friction the car is currently experiencing
turn_speed = 2 //How many degrees the car turns each step
min_turn_speed = 5 //Slowest the car can be traveling and still turn full speed
accel = .2 //How fast the car speeds up
brake = .3 //How fast the car slows down
nitrus_max = 100 //Number of steps the player can use nitrus
nitrus = nitrus_max
nitrus_on = false //Whether the nitrus is activated or not
nitrus_boost = 2 //Percent increase to acceleration when nitrus is activated
gear = 1 //Which gear the vehicle is in. 0 = reverse 1-4 = 1st to 4th gear
max_gear = 5
gear_max_speed = [-4, 4, 7, 10, 15, 20]
gear_min_speed = [0, 0, 3, 6, 9, 14]
max_speed = gear_max_speed[max_gear]
shift_period = 30 //Number of steps it takes to shift up a gear
current_shift_period = 0 //How many steps the player has attempted to upshift
current_reverse_period = 0 //How many steps the player has attempted to reverse
traction = .6 //Portion of max speed the vehicle can travel without losing traction
retraction_rate = 1 //The number of degrees the vehicle's direction realigns with its orientation per step
hp_max = 60 //Vehicle's maximum health

hp = hp_max //Vehicles's current health
sprite_index = spr_car

Player = noone

picked_up_deliveries = ds_list_create()

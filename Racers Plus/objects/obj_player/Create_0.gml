/// @description Set Vehicle Model Variables

//Changeable Vehicle Variables

model = 0 //The current model of the vehicle
//Models 0 = Red Car, 1 = Police Car, 2 = Sport's car, 3 = Taxi 4 = Ambulance
//5 = Pickup, 6 = Van, 7 = Orange Car, 8 = Semi
model_turn_speeds = [1.5, 3, 4, 3, 2, 2.5, 1.5, 1.5, 2.5, 1] //How many degrees the car turns each step
model_accels = [.1, .25, .3, .2, .15, .1, .15, .2, .05] //How fast the car speeds up
model_brakes = [.2, .3, .25, .3, .15, .15, .2, .2, .1] //How fast the car slows down
model_nitrus_maxes = [0, 50, 100, 30, 20, 20, 30, 30, 100] //Number of steps the player can use nitrus
model_max_gears = [3, 5, 6, 4, 3, 5, 4, 4, 5] 
model_gear_max_speeds = [[-2, 2, 4, 7], [-4, 3, 6, 9, 12, 16], [-2, 2, 4, 7, 10, 15, 22], [-3, 2, 4, 7, 10], [-2, 2, 4, 9], [-2, 2, 4, 6, 9, 12], [-3, 3, 6, 9, 14], [-2, 2, 4, 6, 9], [-.5, 1.5, 3, 5, 8, 12]]
model_gear_min_speeds = [[0, 0, 1, 3], [0, 0, 2, 5, 8, 11], [0, 0, 1, 3, 6, 9, 14], [0, 0, 1, 3, 6], [0, 0, 1, 3], [0, 0, 1, 3, 5, 8], [0, 0, 2, 5, 8], [0, 0, 1, 3, 5], [0, 0, 1, 2, 4, 7]]
model_shift_periods = [35, 20, 25, 30, 35, 40, 30, 30, 50] //Number of steps it takes to shift up a gear
model_tractions = [.6, .7, .5, .6, .8, .65, .6, .7, .6] //Portion of max speed the vehicle can travel without losing traction
model_hp_maxes = [20, 45, 30, 40, 70, 60, 50, 35, 100] //Vehicle's maximum health

//Create vehicle
event_user(0)
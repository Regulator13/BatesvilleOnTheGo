/// @description Set Vehicle Model Variables

//Changeable Vehicle Variables

model = 0 //The current model of the vehicle
//Models 0 = Red Car, 1 = Police Car, 2 = Sport's car, 3 = Taxi 4 = Ambulance
//5 = Pickup, 6 = Van, 7 = Orange Car, 8 = Semi
model_turn_speeds = [1.5, 2, 3, 2, 1.5, 1.25, 1.25, 1.5, 1] //How many degrees the car turns each step
model_accels = [.01, .02, .03, .015, .0125, .01, .0125, .015, .008] //How fast the car speeds up
model_brakes = [.05, .075, .065, .075, .04, .04, .05, .05, .025] //How fast the car slows down
model_nitrus_maxes = [0, 50, 100, 30, 20, 20, 30, 30, 100] //Number of steps the player can use nitrus
model_max_gears = [3, 5, 6, 4, 3, 5, 4, 4, 5] 
model_gear_max_speeds = [[-1, 1, 1.5, 3], [-1.5, 1, 2, 3, 4, 5.5], [-1, 1, 1.5, 3, 4.5, 6, 7], [-1, 1, 1.5, 2.5, 4], [-1, 1, 1.5, 3.5], [-1, 1, 1.5, 2.5, 4, 5.5], [-1.5, 1.5, 2.5, 4, 6], [-1, 1, 1.5, 2.5, 4], [-.25, .5, 1, 2, 3.5, 5]]
model_gear_min_speeds = [[0, 0, 0.5, 1], [0, 0, 1, 2, 3, 4], [0, 0, .5, 1, 2, 3, 5], [0, 0, .5, 1, 2], [0, 0, .5, 1], [0, 0, .5, 1, 2, 3], [0, 0, 1, 2, 3], [0, 0, .5, 1, 2], [0, 0, .3, .5, 1, 2.5]]
model_shift_periods = [35, 25, 25, 30, 35, 40, 30, 30, 50] //Number of steps it takes to shift up a gear
model_tractions = [.6, .7, .5, .6, .8, .65, .6, .7, .6] //Portion of max speed the vehicle can travel without losing traction
model_hp_maxes = [20, 45, 30, 40, 70, 60, 50, 35, 100] //Vehicle's maximum health
model_cost = [10, 20, 30, 40, 50, 60, 70, 80, 90]
vehicle_sprites = [spr_car, spr_police, spr_racecar, spr_taxi, spr_ambulance, spr_truck, spr_van, spr_widecar, spr_semi]
Car = noone

tips = 0

inputs = array_create(5, KEY_ISRELEASED)
//Controls are stored in a multidimensional array
//controls is the index to use to determine the controls preset
controls = global.player_counter++

//Create vehicle
event_user(0)
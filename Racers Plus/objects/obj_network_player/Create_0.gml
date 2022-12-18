/// @description Initialize variables
//server-side player object tracker

//Changeable Vehicle Variables

model = 0 //The current model of the vehicle
//Models 0 = Red Car, 1 = Police Car, 2 = Sport's car, 3 = Taxi 4 = Ambulance
//5 = Pickup, 6 = Van, 7 = Orange Car, 8 = Semi
model_turn_speeds = [1.5, 2, 3, 2, 1.5, 1.25, 1.25, 1.5, 1] //How many degrees the car turns each step
model_accels = [.01, .017, .023, .014, .0125, .01, .0125, .015, .008] //How fast the car speeds up
model_brakes = [.05, .075, .065, .075, .04, .04, .05, .05, .025] //How fast the car slows down
model_nitrus_maxes = [0, 50, 100, 30, 20, 20, 30, 30, 100] //Number of steps the player can use nitrus
model_max_gears = [3, 5, 6, 4, 3, 5, 4, 4, 5] 
model_gear_max_speeds = [[-1, 1, 1.5, 3], [-1.5, 1, 2, 3, 4, 5.5], [-1, 1, 1.5, 3, 4.5, 6, 7], [-1, 1, 1.5, 2.5, 4], [-1, 1, 1.5, 3.5], [-1, 1, 1.5, 2.5, 4, 5.5], [-1.5, 1.5, 2.5, 4, 6], [-1, 1, 1.5, 2.5, 4], [-.25, .5, 1, 2, 3.5, 5]]
model_gear_min_speeds = [[0, 0, 0.5, 1], [0, 0, 1, 2, 3, 4], [0, 0, .5, 1, 2, 3, 5], [0, 0, .5, 1, 2], [0, 0, .5, 1], [0, 0, .5, 1, 2, 3], [0, 0, 1, 2, 3], [0, 0, .5, 1, 2], [0, 0, .3, .5, 1, 2.5]]
model_shift_periods = [35, 25, 25, 30, 35, 40, 30, 30, 50] //Number of steps it takes to shift up a gear
model_tractions = [.6, .7, .5, .6, .8, .65, .6, .7, .6] //Portion of max speed the vehicle can travel without losing traction
model_hp_maxes = [20, 45, 30, 40, 70, 60, 50, 35, 100] //Vehicle's maximum health
model_weights = [8, 8, 6, 10, 18, 16, 20, 15, 50]
model_cost = [10, 20, 30, 40, 50, 60, 70, 80, 90]
vehicle_sprites = [spr_car, spr_police, spr_racecar, spr_taxi, spr_ambulance, spr_truck, spr_van, spr_widecar, spr_semi]
Car = noone

//name - player name
player_name = ""
player_color = 0
ready_to_start = false

// Team tracker set in obj_server Step event when sending SERVER_STATESWITCH from STATE_LOBBY
Team = noone

//connection details of connecting client used to send messages back
tcp_socket = -1
udp_port = -1

//order in which client connected
connect_id = -1

//simple messages from the server to send out
messages_out = ds_queue_create()

//UDP sequences
udp_sequence_out = 0

//whether this player extends off another who has the client
extended = false

#region Speed control
//desired milliseconds per frame for client to run at
//set in obj_server Step Event when game starts
set_millipf = -1
//previous set milliseconds per frame since server is always one message ahead
//start at the value set in obj_client because the first turn is the last turn
//which was never actually ran but set at default
//Warning! must match speed set in obj_client or else first set calculation will be off
//set in obj_server Step Event when game starts
prev_set_millipf = -1
//reported actual fps per turn from client
actual_millipf = array_create(obj_server.turns_per_set)
//the lowest average millipf this client has maintained
//start at -1 so server can check if has been set before starting
min_millipf = -1
//a client can process one turn ahead of the server client before stopping
//which means it can be one set turn ahead of the server
//this is not a problem unitl the changing of set turns
last_set_actual_millipf = array_create(obj_server.turns_per_set)
set_complete = false
//which turn is the client on for this set
//starts at zero because this is the first turn it will record
set_turn = 0
//set number player is on
set = 0
//milliseconds client is off from server, negative for behind
milliseconds_off_server = 0
///Debug
performance = -1

//currentRTT - store the current round trip time for messages
//use -1 to indicate no actual data yet
RTT = -1
//whether client has replied to the last ping sent to it
waiting_on_reply = false
#endregion

//ip - ip of client, used for disconnecting
ip = 0

//dropBuffer - steps before a client is dropped, from not recieving a ping
dropBuffer = 60

#region Debug

//messageSuccess - whether the message was succesful sent
messageSuccess = -1;
#endregion

#region Lobby
Section = noone
#endregion
/// @description Initialize variables
//server-side player object tracker

// obj_player instance	
Player = noone

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
/// @description Initialize server

//set by obj_session
server_name = ""
server_ip = ""

global.have_server = true
randomize()
game_seed = random_get_seed()

//counters
global.connect_id = 0

//buffer alignment is one to minimize wasted space by writing as compactly as possible
var alignment = 1
//Caution! Potential memory leak. Buffers are not deleted when restarting a game, must be done manually
broadcast_buffer = buffer_create(32, buffer_fixed, alignment)
game_buffer = buffer_create(32, buffer_grow, alignment)

//identify client object with ip from iplist

//store all players in ds_map since clients are given a key to reference them
//cannot be a list otherwise key could change
//stores obj_network_player for each client
//keys are the connect_ids
Network_players = ds_map_create()

//list of active connect_ids for better ds_map iteration
active_connect_ids = ds_list_create()
//list of client connect_ids for only players with dedicated clients
client_connect_ids = ds_list_create()

//clientBuffer - buffer for small client messages
//Caution! Potential memory leak. Buffers are not deleted when restarting a game, must be done manually
confirmBuffer = buffer_create(24, buffer_grow, alignment)

//try and create the actual server
//server creation may fail if there is already a server running
broadcast_server = obj_session.broadcast_server
udp_server = network_create_server(network_socket_udp, UDP_PORT, 32)
tcp_server = network_create_server(network_socket_ws, TCP_PORT, 32)
if udp_server < 0 or tcp_server < 0{    
    //if theres already a server running, shut down and delete
    instance_destroy()
}

//load server settings
ini_open("server.ini")
max_millipf = ini_read_real("performance", "max_millipf", 33)
seconds_between_pings = ini_read_real("performance", "seconds_between_pings", 5)
turns_per_set = ini_read_real("performance", "turns_per_set", 6)
ini_close()

//setup a timer so we can broadcast the server IP out to local clients looking...
alarm[0] = BROADCAST_RATE

//pinging
alarm[1] = seconds_between_pings*game_get_speed(gamespeed_fps)

//serverDebug - whether or not to draw server debug information
serverDebug = false

///Debug
record_logs = false
if record_logs{
	server_messages_log = file_text_open_write(working_directory + "server_messages.log")
	server_speed_log = file_text_open_write(working_directory + "server_speed.log")
	server_speed_data = file_text_open_write(working_directory + "server_speed.csv")
}
else{
	server_messages_log = -1
	server_speed_log = -1
	server_speed_data = -1
}
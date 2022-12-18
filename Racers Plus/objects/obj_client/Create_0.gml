/// @description Initialize client
//Created with action to join a game

//Global trackers
global.Client = self
global.step_counter = 0

//Unique identifiers
//set by obj_session
player_name = ""

Player = noone

#region Score Networking
Teams = ds_list_create()
#endregion

#region Networking
//state is NETWORK_CONNECT until both TCP and UDP connections are established
network_state = NETWORK_TCP_CONNECT

//used to know when to assume the server disconnected
disconnect_after_seconds = 2

//create a buffer for the network messages
//buffer alignment is one to minimize wasted space by writing as compactly as possible
var alignment = 1;
//Caution! Potential memory leak. Buffers are not deleted when restarting a game, must be done manually
buff = buffer_create(256, buffer_grow, alignment)

#region UDP
//create a UDP socket
udp_client = network_create_socket(network_socket_udp)
//server communication
port = UDP_PORT

//UDP realiabilty, ordering, and congestion avoidance for UDP
//stores latest packet sequence that the client has recieved
sequenceIn = -1	

//attempt to UDP connect to server
connect_udp_tries = 0  //set after TCP connection
#endregion

#region TCP
tcp_client = network_create_socket(network_socket_ws)
//TCP socket of server to send messages
server_tcp_socket = -1
#region TCP connection
if (tcp_client < 0)
	show_debug_message("Warning: Creating TCP socket failed")
else{
	//TCP connection timeout since it is not asynchronous
	network_set_config(network_config_connect_timeout, 4000)
	
	//attempt TCP connect
	network_connect_async(tcp_client, global.connectip, TCP_PORT)
}
#endregion
#endregion

//network indentifiers
//uses connect_id as keys
Network_players = ds_map_create()
//list to iterate through Network_players
active_connect_ids = ds_list_create()

//used to identify which client this is to the server
connect_id = -1	 //order in which client connected to server, not an index to any list!
#endregion

//average real fps for performance reports to the server
total_real_fps = 0
count_real_fps = 0
average_actual_fps = -1
maximum_actual_fps = -1
previous_actual_fps = ds_list_create()
previous_real_fps = ds_list_create()


#region Debug
//record turns at the end of each communication turn
record_logs = true
if record_logs{
	debug_log = file_text_open_write(working_directory + "debug.log")
	client_messages_log = file_text_open_write(working_directory + "client_messages.log")
	client_speed_log = file_text_open_write(working_directory + "client_speed.log")
}
else{
	debug_log = -1
	client_messages_log = -1
	client_speed_log = -1
}

//clientDebug - whether to show debug for the client
clientDebug = false;

//msgIDin - the latest server message ID
msgIDin = 0;

//socketIn - the socket id coming in from the server
socketIn = -1;

//serverIP - IP address of where message are coming in from
serverIP = -1;
#endregion

//perform stress test
//instance_create_layer(0, 0, "lay_networking", obj_performance_tester)

/// @description Initialize client
// Created with action to join a game

// Periodic updates to the server, made available for integration use
// Normally turned on during game, and off during SCORE/GAMECONFIG menus
// Set in scr_networking_client_interface
update_1_wait = -1
update_2_wait = -1
// Functions
networking_declare_client_interface_functions()

// Unique identifiers
// Set by obj_session
player_name = ""

#region Networking
// client_debug - whether to show debug for the client
client_debug = false

last_msg_id_received = 0
server_ip = ""

//state is NETWORK_CONNECT until both TCP and UDP connections are established
network_state = NETWORK_TCP_CONNECT

//used to know when to assume the server disconnected
disconnect_after_seconds = 4

//create a buffer for the network messages
//buffer alignment is one to minimize wasted space by writing as compactly as possible
var alignment = 1;
//Caution! Potential memory leak. Buffers are not deleted when restarting a game, must be done manually
message_buffer = buffer_create(256, buffer_grow, alignment)

#region TCP
tcp_client = network_create_socket(network_socket_ws)
//TCP socket of server to send messages
server_tcp_socket = -1

#endregion

Network_player = instance_create_layer(0, 0, "lay_instances", obj_network_player)

//used to identify which client this is to the server
connect_id = -1	 //order in which client connected to server, not an index to any list!

// UDP sequences
udp_sequence_out = 0
// RTT calculations
RTT = -1
ping_out = 0
// Time in seconds, should be less than 20 (obj_authoritative player)
ping_wait = 2*game_get_speed(gamespeed_fps)
#endregion

#region Message log
global.message_log = file_text_open_write("messages.log")

log_message = function(entry) {
	show_debug_message(string("obj_client {0}", entry))
	/*
	file_text_write_string(global.message_log, string("obj_client {0}", entry))
	file_text_writeln(global.message_log)
	*/
}
#endregion
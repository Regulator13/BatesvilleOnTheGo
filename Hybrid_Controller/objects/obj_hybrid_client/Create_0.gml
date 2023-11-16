/// @description Initialize client
// Created with action to join a game

// Functions
phone_client_declare_interface_functions()

// Unique identifiers
// Set by obj_session
player_name = ""

#region Networking
// client_debug - whether to show debug for the client
client_debug = false

last_msg_id_received = 0
server_ip = ""

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

Player = instance_create_layer(0, 0, "lay_instances", obj_player)

//used to identify which client this is to the server
connect_id = -1	 //order in which client connected to server, not an index to any list!

// Time in seconds, should be less than 20 (obj_authoritative player)
ping_wait = 2*game_get_speed(gamespeed_fps)

alarm[3] = ping_wait
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
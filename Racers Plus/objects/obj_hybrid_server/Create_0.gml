/// @description Initialize server

// Functions
hybrid_server_declare_interface_functions()

server_name = ""

#region Networking
global.have_hybrid_server = true

//counters
global.hybrid_connect_id = 0

var alignment = 1
//Caution! Potential memory leak. Buffers are not deleted when restarting a game, must be done manually
action_buffer = buffer_create(32, buffer_grow, alignment)

// Authoratative list of network players
//store all players in ds_map since clients are given a key to reference them
//cannot be a list otherwise key could change
//stores obj_connected_hybrid_client for each client
//keys are the connect_ids
Connected_hybrid_clients = ds_map_create()

//list of active connect_ids for better ds_map iteration
active_connect_ids = ds_list_create()
//list of client connect_ids for only players with dedicated clients
// This is necessary as mulitple players can share one client
client_connect_ids = ds_list_create()

//clientBuffer - buffer for small client messages
//Caution! Potential memory leak. Buffers are not deleted when restarting a game, must be done manually
confirm_buffer = buffer_create(24, buffer_grow, alignment)

// Try and create the actual server
// Server creation may fail if there is already a server running
tcp_server = network_create_server_raw(network_socket_ws, TCP_PORT, 32)
if tcp_server < 0{    
    // If theres already a server running, shut down and delete
    instance_destroy()
}
#endregion

// server_debug - whether or not to draw server debug information
server_debug = false

#region Message log
global.message_log = file_text_open_write("messages.log")

log_message = function(entry) {
	file_text_write_string(global.message_log, string("obj_hybrid_server {0}", entry))
	file_text_writeln(global.message_log)
}
#endregion
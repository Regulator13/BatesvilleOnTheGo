/// @description TCP connection
if (tcp_client < 0)
	show_debug_message("Warning: Creating TCP socket failed")
else{
	//TCP connection timeout since it is not asynchronous
	network_set_config(network_config_connect_timeout, 4000)
	
	//attempt TCP connect
	network_connect_raw_async(tcp_client, server_ip, TCP_PORT)
	
	log_message(scr_network_state_to_string(network_state))
	log_message("-> TCP Connect")
}
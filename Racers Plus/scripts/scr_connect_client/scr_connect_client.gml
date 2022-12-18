/// @function scr_connect_client(connect_id, ip, port, socket)
/// @description connects a client to the server, disconnections handled in obj_network_player
//  Returns obj_network_player
function scr_connect_client(connect_id, ip, port, socket){
	//check if this client is already connected
	var Network_player = Network_players[? connect_id]
	if is_undefined(Network_player){
		//create a new network player to store all details
	    Network_player = instance_create_layer(0, 0, "lay_instances", obj_network_player)
	    Network_player.ip = ip
		Network_player.tcp_socket = socket
		Network_player.udp_port = port
		Network_player.connect_id = connect_id
    
	    //put this instance into a map, using the connect_id as the lookup
	    ds_map_add(Network_players, connect_id, Network_player)
		ds_list_add(active_connect_ids, connect_id)
	    }
	//disconnecting handled in obj_network_player
	
	//if socket given than a TCP connection, else UDP and need to set port
	if socket == -1{
		Network_player.udp_port = port
	}
	else{
		Network_player.tcp_socket = socket
	}
	
	return Network_player
}

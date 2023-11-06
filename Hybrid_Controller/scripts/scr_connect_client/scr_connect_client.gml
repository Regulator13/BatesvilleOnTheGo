/// @function server_connect_client(connect_id, ip, port, socket)
/// @description connects a client to the server, disconnections handled in obj_Connected_client
//  Returns obj_Connected_client
function server_connect_client(connect_id, ip, port, socket){
	//check if this client is already connected
	var Connected_client = Connected_clients[? connect_id]
	if is_undefined(Connected_client){
		//create a new network player to store all details
	    Connected_client = instance_create_layer(0, 0, "lay_instances", obj_connected_client)
	    Connected_client.ip = ip
		Connected_client.tcp_socket = socket
		Connected_client.udp_port = port
		Connected_client.connect_id = connect_id
    
	    //put this instance into a map, using the connect_id as the lookup
	    ds_map_add(Connected_clients, connect_id, Connected_client)
		ds_list_add(active_connect_ids, connect_id)
	    }
	//disconnecting handled in obj_Connected_client
	
	//if socket given than a TCP connection, else UDP and need to set port
	if socket == -1{
		Connected_client.udp_port = port
	}
	else{
		Connected_client.tcp_socket = socket
	}
	
	return Connected_client
}

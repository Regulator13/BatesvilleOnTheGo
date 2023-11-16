/// @function server_connect_hybrid_client(connect_id, ip, socket)
/// @description connects a client to the server, disconnections handled in obj_Connected_hybrid_client
//  Returns obj_Connected_hybrid_client
function server_connect_hybrid_client(connect_id, ip, socket){
	//check if this client is already connected
	var Connected_hybrid_client = Connected_hybrid_clients[? connect_id]
	if is_undefined(Connected_hybrid_client){
		//create a new network player to store all details
	    Connected_hybrid_client = instance_create_layer(0, 0, "lay_instances", obj_connected_hybrid_client)
	    Connected_hybrid_client.ip = ip
		Connected_hybrid_client.tcp_socket = socket
		Connected_hybrid_client.connect_id = connect_id
    
	    //put this instance into a map, using the connect_id as the lookup
	    ds_map_add(Connected_hybrid_clients, connect_id, Connected_hybrid_client)
		ds_list_add(active_connect_ids, connect_id)
	}
	//disconnecting handled in obj_connected_hybrid_client
	
	return Connected_hybrid_client
}

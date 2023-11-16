/// @function server_find_hybrid_client(ip, socket)
/// @description Return back the obj_network_player related to the ip and socket
function server_find_hybrid_client(ip, socket){
	var count = instance_number(obj_connected_hybrid_client)
	for (var i=0; i<count; i++){
		var Network_player = instance_find(obj_connected_hybrid_client, i)
		if Network_player.ip == ip and Network_player.tcp_socket == socket{
			return Network_player
		}
	}
}
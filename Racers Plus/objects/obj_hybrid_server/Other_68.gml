/// @description Server network control
var eventid = ds_map_find_value(async_load, "id")
var type = ds_map_find_value(async_load, "type")
var ip = async_load[? "ip"]

#region TCP messages
if type == network_type_connect{
	var socket = async_load[? "socket"]
	
	show_debug_message("Client " + ip + " has connected with socket " + string(socket))
	
	//this is a brand new client so get it a new connect id
	var connect_id = global.hybrid_connect_id++
	//connecting through TCP
	ds_list_add(client_connect_ids, connect_id)
	var Connected_hybrid_client = server_connect_hybrid_client(connect_id, ip, socket)
	
	//inform client of their connect_id so that they can UDP connect
	buffer_seek(confirm_buffer, buffer_seek_start, 2)
	//write msg_id
	buffer_write(confirm_buffer, buffer_s8, HYBRID_SERVER_CONNECT)            
	//send confirmation to the client
	hybrid_server_send_TCP(Connected_hybrid_client, confirm_buffer, buffer_tell(confirm_buffer))
	
	log_message(string("<- TCP Connect IP {0} socket {1}", ip, socket))
}
else if type == network_type_disconnect{
	//disconnect the client based on the ip and socket combo
	var socket = async_load[? "socket"]
		
	//find the related network player
	var Connected_hybrid_client = server_find_hybrid_client(ip, socket)
	instance_destroy(Connected_hybrid_client)
		
	log_message(string("<- TCP Disconnect IP {0} socket {1}", ip, socket))
}
else if type == network_type_data{
	//find buffer
	var buff = ds_map_find_value(async_load, "buffer");
	///Debug show length
	var buffer_size = buffer_get_size(buff)

	//find start
	buffer_seek(buff, buffer_seek_start, 0)

	//ensure correct GAME ID
	if buffer_read(buff, buffer_u8) == GAME_ID{
		//read message id
		var connect_id = buffer_read(buff, buffer_u8)
		var msg_id = buffer_read(buff, buffer_s8)
		var Connected_hybrid_client = Connected_hybrid_clients[? connect_id]
			
		log_message(string("<- TCP {0}", scr_hybrid_msg_id_to_string(msg_id)))
			
		if is_undefined(Connected_hybrid_client){
			show_debug_message("Warning! TCP message with incorrect connect_id")
			show_debug_message("Client " + string(connect_id) + " message " + scr_hybrid_msg_id_to_string(msg_id))
			var socket = async_load[? "socket"]
			var port = async_load[? "port"]
			show_debug_message("Socket: " + string(socket) + " Port: " + string(port))
		}
		else{
			switch msg_id{
				case HYBRID_CLIENT_PING:
					Connected_hybrid_client.alarm[0] = Connected_hybrid_client.drop_wait
							
					#region Reply
					// This message is ultimately ignored, just to keep port open with NAT
					var reply_buffer = buffer_create(5, buffer_fixed, 1)
							
					// GAME_ID and connect_id are added by scr_server_sent_UDP
					buffer_seek(reply_buffer, buffer_seek_start, 2)
                    
					//write msg_id
					buffer_write(reply_buffer, buffer_s8, HYBRID_SERVER_PING)
							
					if not hybrid_server_send_TCP(Connected_hybrid_client, reply_buffer, buffer_tell(reply_buffer)){
						show_debug_message("Warning: TCP ping message to client failed to send")
					}
					buffer_delete(reply_buffer)
						
					log_message("-> TCP HYBRID_SERVER_PING")
					#endregion
					break
				case HYBRID_CLIENT_PLAY:
					// Actions are fed back to the obj_player providing context for performance
					// obj_player instances
					var Player = Connected_hybrid_client.Player
					
					var action = buffer_read(buff, buffer_u8)
					
					Player.read_action(action, buff)
					
					log_message(string("<- TCP ACTION {0}", scr_action_to_string(action)))
					break
					break
				default:
					show_debug_message("Warning! TCP message msg_id not caught: " + string(msg_id))
					show_debug_message("Was this really a TCP message meant for the server?")
					break
			}
		}
	}
}
#endregion

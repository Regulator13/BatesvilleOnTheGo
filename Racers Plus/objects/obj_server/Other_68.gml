/// @description Server network control
var eventid = ds_map_find_value(async_load, "id")
var type = ds_map_find_value(async_load, "type")
var ip = async_load[? "ip"]
	
#region UDP messages
if eventid == udp_server {
	if type == network_type_data{
		//find buffer
		var buff = ds_map_find_value(async_load, "buffer");
		///Debug show length
		var buffer_size = buffer_get_size(buff)

		//find start
		buffer_seek(buff, buffer_seek_start, 0);

		//ensure correct GAME ID
		if buffer_read(buff, buffer_u8) == GAME_ID {
			//read message id
			var connect_id = buffer_read(buff, buffer_u8)
			var msg_id = buffer_read(buff, buffer_s8)
			var Connected_client = Connected_clients[? connect_id]
			
			log_message(string("<- UDP {0}", scr_msg_id_to_string(msg_id)))
			
			// Connected_client could be undefined if a ping is recieved late and the player
			// is already dropped
			if not is_undefined(Connected_client) {
				switch (msg_id) {
				    case CLIENT_CONNECT:
				        //client connecting via UDP
						var port = async_load[? "port"]
						//since this is UDP and the packet will be sent many times,
						//make sure the port is not already set
						if Connected_client.udp_port != port{
							//send no socket as this is a UDP connection
					        server_connect_client(connect_id, ip, port, -1)
							//inform client of succesful connection
							ds_queue_enqueue(Connected_client.messages_out, SERVER_CONNECT)
						}
				        break
					default:
						// Integration can declare unique msg_ids
						read_regular_message(msg_id, buff, Connected_client)
						break
				}
			}
		}
		else {
			// Is the socket set to be reliable on both client and server?
			show_debug_message("Warning! Other game messages received.")
		}
	}
}
#endregion

#region TCP messages
//cant do eventid == tcp_server because each TCP connection creates a different event_id
else if instance_exists(obj_client) and eventid != obj_client.tcp_client and eventid != obj_client.udp_client {
	if type == network_type_connect{
		var socket = async_load[? "socket"]
	
		show_debug_message("Client " + ip + " has connected with socket " + string(socket))
	
		//this is a brand new client so get it a new connect id
		var connect_id = global.connect_id++
		//connecting through TCP so not an extended client
		ds_list_add(client_connect_ids, connect_id)
		var Connected_client = server_connect_client(connect_id, ip, -1, socket)
	
		//inform client of their connect_id so that they can UDP connect
		ds_queue_enqueue(Connected_client.messages_out, SERVER_CONNECT)
		
		log_message(string("<- TCP Connect IP {0} socket {1}", ip, socket))
	}
	else if type == network_type_disconnect{
		//disconnect the client based on the ip and socket combo
		var socket = async_load[? "socket"]
		
		//find the related network player
		var Connected_client = scr_find_client(ip, socket)
		instance_destroy(Connected_client)
		
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
			var Connected_client = Connected_clients[? connect_id]
			
			log_message(string("<- TCP {0}", scr_msg_id_to_string(msg_id)))
			
			if is_undefined(Connected_client){
				show_debug_message("Warning! TCP message with incorrect connect_id")
				show_debug_message("Client " + string(connect_id) + " message " + scr_msg_id_to_string(msg_id))
				var socket = async_load[? "socket"]
				var port = async_load[? "port"]
				show_debug_message("Socket: " + string(socket) + " Port: " + string(port))
			}
			else{
				Connected_client.alarm[0] = Connected_client.drop_wait
				switch msg_id{
					case CLIENT_PING:
						Connected_client.alarm[3] = Connected_client.drop_wait
							
						#region Reply
						// This message is ultimately ignored, just to keep port open with NAT
						var reply_buffer = buffer_create(5, buffer_fixed, 1)
							
						// GAME_ID and connect_id are added by scr_server_sent_UDP
					    buffer_seek(reply_buffer, buffer_seek_start, 2)
                    
					    //write msg_id
					    buffer_write(reply_buffer, buffer_s8, SERVER_PING)
							
						if not server_send_TCP(Connected_client, reply_buffer, buffer_tell(reply_buffer)){
							show_debug_message("Warning: TCP ping message to client failed to send")
						}
						buffer_delete(reply_buffer)
						
						log_message("-> TCP SERVER_PING")
						#endregion
						break
				    case CLIENT_LOGIN:
						//set the client "name"
						var player_name = buffer_read(buff, buffer_string)
						//client logging in
						scr_login_client(Connected_client, player_name)
						break
					case CLIENT_PLAY:
						//all other sockets are connected client sockets, and we have recieved commands from them.
						scr_server_received_data(Connected_client, buff)
						break
					default:
						show_debug_message("Warning! TCP message msg_id not caught: " + string(msg_id))
						show_debug_message("Was this really a TCP message meant for the server?")
						break
				}
			}
		}
	}
}
#endregion

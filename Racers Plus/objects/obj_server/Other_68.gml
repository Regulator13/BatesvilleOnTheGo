/// @description Server network control
var eventid = ds_map_find_value(async_load, "id")
var type = ds_map_find_value(async_load, "type")
var ip = async_load[? "ip"]

if eventid == broadcast_server{
	server_ip = ip
}
	
#region UDP messages
if eventid == udp_server{
	if type == network_type_data{
		//find buffer
		var buff = ds_map_find_value(async_load, "buffer");
		///Debug show length
		var buffer_size = buffer_get_size(buff)

		//find start
		buffer_seek(buff, buffer_seek_start, 0);

		//ensure correct GAME ID
		if buffer_read(buff, buffer_u8) == GAME_ID{
			//read message id
			var connect_id = buffer_read(buff, buffer_u8)
			var msg_id = buffer_read(buff, buffer_s8)
			var Network_player = Network_players[? connect_id]

			switch msg_id{
			    case CLIENT_CONNECT:
			        //client connecting via UDP
					var port = async_load[? "port"]
					//since this is UDP and the packet will be sent many times,
					//make sure the port is not already set
					if Network_player.udp_port != port{
						//send no socket as this is a UDP connection
				        scr_connect_client(connect_id, ip, port, -1)
						//inform client of succesful connection
						ds_queue_enqueue(Network_player.messages_out, SERVER_CONNECT)
					}
			        break
			}
		}
	}
}
#endregion

#region TCP messages
//cant do eventid == tcp_server because each TCP connection creates a different event_id
else if eventid != broadcast_server and (instance_exists(obj_client) and eventid != obj_client.tcp_client and eventid != obj_client.udp_client){
	if type == network_type_connect{
		var socket = async_load[? "socket"]
	
		show_debug_message("Client " + ip + " has connected with socket " + string(socket))
	
		//this is a brand new client so get it a new connect id
		var connect_id = global.connect_id++
		//connecting through TCP so not an extended client
		ds_list_add(client_connect_ids, connect_id)
		var Network_player = scr_connect_client(connect_id, ip, -1, socket)
	
		//inform client of their connect_id so that they can UDP connect
		ds_queue_enqueue(Network_player.messages_out, SERVER_CONNECT)
	}
	else if type == network_type_disconnect{
		//disconnect the client based on the ip and socket combo
		var socket = async_load[? "socket"]
		
		//find the related network player
		var Network_player = scr_find_client(ip, socket)
		instance_destroy(Network_player)
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
			var Network_player = Network_players[? connect_id]
			
			if is_undefined(Network_player){
				show_debug_message("Warning! TCP message with incorrect connect_id")
				show_debug_message("Client " + string(connect_id) + " message " + scr_msg_id_to_string(msg_id))
				var socket = async_load[? "socket"]
				var port = async_load[? "port"]
				show_debug_message("Socket: " + string(socket) + " Port: " + string(port))
			}
			else{
				switch msg_id{
				    case CLIENT_CONNECT:
				        //client connecting via UDP
						var port = async_load[? "port"]
						//send no socket as this is a UDP connection
				        scr_connect_client(connect_id, ip, port, -1)
						//inform client of succesful connection
						ds_queue_enqueue(Network_player.messages_out, SERVER_CONNECT)
				        break
				    case CLIENT_LOGIN:
						//set the client "name"
						var player_name = buffer_read(buff, buffer_string)
				        //client logging in
				        scr_login_client(Network_player, player_name)
				        break
				    case CLIENT_PLAY:
				        //all other sockets are connected client sockets, and we have recieved commands from them.
				        scr_server_received_data(Network_player, buff)
				        break
					case CLIENT_PING:
						//get obj_network_player
						var Client = Network_player
						//microseconds
						Client.RTT = get_timer() - ping_out
						//remove client from waiting list for replys
						Client.waiting_on_reply = false
						break
					case CLIENT_PERFORMANCE:
						var Client = Network_player
						//each client reports its performance for the turn it just completed
						var actual_millipf = buffer_read(buff, buffer_u8)
						if obj_menu.state == STATE_LOBBY{
							Client.min_millipf = actual_millipf
						}
						else if obj_menu.state == STATE_GAME{
							//the first message recieved is for the first turn in the first set
							Client.actual_millipf[Client.set_turn] = actual_millipf
						
							//check if client has reached the end of their messages
							var Server_client = ds_map_find_value(Network_players, client_connect_ids[| obj_client.connect_id])
							if Client != Server_client{//Client.set_turn > Server_client.set_turn or Server_client.set_turn != 0 and Client.set_turn == 0{
								//scr_server_log_speed_wait(server_speed_log, connect_id, Client.set_turn, Server_client.set_turn)
							}
						
							//check if client finished the set
							if Client.set_turn == turns_per_set{
								//enqueue this array to allow client to start recording for the next
								//this allows client to process one message ahead of server client
								//which will pause the client while it is waiting on the next message
								array_copy(Client.last_set_actual_millipf, 0, Client.actual_millipf, 0, turns_per_set)
								Client.set_complete = true
								Client.set_turn = 0
								Client.set++
								//check if server was previously waiting on this client
								if ds_list_size(waiting_on_clients){
									var was_waiting = ds_list_find_index(waiting_on_clients, Client.connect_id)
									if was_waiting != -1{
										show_debug_message("Server was waiting on this client to catch up.")
										ds_list_delete(waiting_on_clients, was_waiting)
										//check if this was the last client the server was waiting on
										if ds_list_empty(waiting_on_clients){
											show_debug_message("This was the last client behind. Unpausing game.")
											//unpause the game
											scr_unpause_game()
											//retry sending the next turn
											event_user(0)
										}
									}
								}
							}
							else Client.set_turn++
						}
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

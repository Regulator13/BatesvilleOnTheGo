/// @description Recieving messages
var eventid = ds_map_find_value(async_load, "id");
socketIn = eventid;  //the socket id coming from the server
serverIP = ds_map_find_value(async_load, "ip");

var type = ds_map_find_value(async_load, "type");
if type == network_type_non_blocking_connect{
	//TCP connection confirmation
	//Warning! This works on the server only!
	var socket = async_load[? "socket"]
	var ip = async_load[? "ip"]
	var succeeded = async_load[? "succeeded"]
	show_debug_message("Server " + ip + " has succeeded (if 1): " + string(succeeded) + " with socket " + string(socket))
}

#region TCP messages
// Need to check network_type_data since connection is asynchronous
if (eventid == tcp_client and type == network_type_data){
	//read buffer data
    var buffer = ds_map_find_value(async_load, "buffer")
	///Debug show length
	var buffer_size = buffer_get_size(buff)
        
    //set cursor to start of buffer
    buffer_seek(buffer, buffer_seek_start, 0)
    
	//ensure message is for this game
	if (buffer_read(buffer, buffer_u8) == GAME_ID){
		//read incoming connection id to ensure it is for this client
		var conn_id = buffer_read(buffer, buffer_u8)
	    //read msg_id, confirmation message, or game message
	    var msg_id = buffer_read(buffer, buffer_s8)
		
		scr_log_receive_tcp_raw(client_messages_log, conn_id, msg_id)
		
		if conn_id == connect_id{
			//still recieving server messages, update disconnect buffer
		    alarm[0] = disconnect_after_seconds*game_get_speed(gamespeed_fps)
		
			//set msgIDin for debug purposes
		    msgIDin = msg_id;
		
			switch network_state{
				case NETWORK_UDP_CONNECT:
					if msg_id == SERVER_CONNECT{
						//TCP and UDP connection complete, login
						network_state = NETWORK_LOGIN
					
						//client has connected to the server, so send our "player name"
					    scr_send_login(self.player_name)
					}
					break
				case NETWORK_LOGIN:
					if msg_id == SERVER_LOGIN{
						//recieved confirmation, move to next state
						network_state = NETWORK_LOBBY
					}
					break
				case NETWORK_LOBBY:
					#region Lobby
					if msg_id == SERVER_PLAY{
						var state = buffer_read(buffer, buffer_u8)
						if state == STATE_LOBBY{
							////TODO
							if connect_id == 0{
								scr_read_lobby(buffer)
							}
							else{
								controller_read_lobby(buffer)
							}
						}
					}
					else if msg_id == SERVER_PING{
						//server is requesting performance information
						scr_client_reply_ping()
					}
					else if msg_id == SERVER_STATESWITCH{
						//recieved confirmation, move to next state
						network_state = NETWORK_PLAY
						
						////TODO
						if global.have_server{
							//Count teams for visibility check
							global.max_teams = obj_lobby.Map.spawn_amount + 1
						
							//set section colors and create keeps
							var count = ds_list_size(obj_lobby.Sections)
							for (var i=0; i<count; i++){
								var Section = obj_lobby.Sections[| i]
								//set an index to reference the section by in the future
								Section.index = i
								if Section.section_type == SPAWN_SECTION{
									//Section.team = Section.Team_box.field
									global.section_color[i] = Section.Color_box.field
								}
							}
							//set player teams and colors
							var count = instance_number(obj_player)
							for (var i=0; i<count; i++){
								var Player = instance_find(obj_player, i)
								// Do not include server host
								if Player.connect_id != 0{
									Player.team = Player.Section.team
									Player.section = Player.Section.index
									Player.player_color = Player.Color_box.field
								}
							
								if Player.connect_id == obj_client.connect_id {
									obj_client.Player = Player
									Player.block_amount = block_amount
								}
							}
						}
						
						// Continually update server
						if connect_id != 0{
							alarm[2] = 1
						}
					
						menu_state_switch(STATE_LOBBY, STATE_GAME)
					}
					#endregion
					break
				case NETWORK_PLAY:
					if msg_id == SERVER_PLAY{
						var state = buffer_read(buffer, buffer_u8)
						if state == STATE_GAME{
							scr_read_game(buffer)
						}
					}
					else if msg_id == SERVER_PING{
						//server is requesting performance information
						scr_client_reply_ping()
					}
					else if msg_id == SERVER_STATESWITCH{
						network_state = NETWORK_SCORE
						menu_state_switch(STATE_GAME, STATE_SCORE)
					}
					break
				case NETWORK_SCORE:
					if msg_id == SERVER_PLAY{
						var state = buffer_read(buffer, buffer_u8)
						if state == STATE_SCORE{
							scr_read_score(buffer)
						}
					}
					else if msg_id == SERVER_STATESWITCH{
						network_state = NETWORK_LOBBY
						menu_state_switch(STATE_SCORE, STATE_LOBBY)
					}
					break
			}
		}
		else{
			if network_state == NETWORK_TCP_CONNECT{
				if msg_id == SERVER_CONNECT{
					connect_id = conn_id
					//store the socket of the server for sending messages to it
					server_tcp_socket = tcp_client
					
					//now attempt to connect via UDP
					network_state = NETWORK_LOGIN//NETWORK_UDP_CONNECT
					// No UDP connection, so send our "player name"
					scr_send_login(self.player_name)
					connect_udp_tries = 0
				}
			}
		}
	}
}
#endregion

#region UDP message
//is this message for our socket?
if (eventid == udp_client){
	//read buffer data
    var buffer = ds_map_find_value(async_load, "buffer")
        
    //always start at start of buffer
    buffer_seek(buffer, buffer_seek_start, 0)
    
	//ensure message is for this game
	if (buffer_read(buffer, buffer_u8) == GAME_ID){
		//ensure message is for this client
		//multiple clients could use the same external ip
		if connect_id == buffer_read(buffer, buffer_u8){
			//read sequence
		    var sequence = buffer_read(buffer, buffer_u8)
		    //read msg_id, confirmation message, or game message
		    var msg_id = buffer_read(buffer, buffer_s8)
			
		    //set msgIDin for debug purposes
		    msgIDin = msg_id

			//if more recent message, check
		    if (scr_sequence_more_recent(sequence, sequenceIn, SEQUENCE_MAX)){
				//this package is newer and therefore requires an update
		        //update sequenceIn
		        sequenceIn = sequence
				
				//still recieving server messages, update disconnect buffer
				alarm[0] = disconnect_after_seconds*game_get_speed(gamespeed_fps)
				
				//get state that server is in
			    var state = buffer_read(buffer, buffer_u8);
			
				if network_state == NETWORK_LOBBY{
			        switch(state) {
			            case STATE_LOBBY:
			                #region Lobby updates
							scr_read_lobby(buffer)
								
							#endregion
							break
					}
				}
	        }
	    }
	}
}
#endregion
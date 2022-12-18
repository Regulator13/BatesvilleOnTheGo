/// @description Client updates

//store real fps for averaging
total_real_fps += fps_real
count_real_fps ++
//utilize moving average smoothing for new fps
ds_list_add(previous_real_fps, fps_real)
//keep only 10 values
if ds_list_size(previous_real_fps) > 10 ds_list_delete(previous_real_fps, 0)

switch network_state{
    case(NETWORK_UDP_CONNECT):
		#region Attempt to connect to server using UDP
        if connect_udp_tries > 0{
            //move to start of buffer. Networking ALWAYS takes the data from the START of a buffer.
            buffer_seek(buff, buffer_seek_start, 0);
    
			//write GAME ID to uniquely define game
			buffer_write(buff, buffer_u8, GAME_ID)
	
			//write identifing connect_id
			buffer_write(buff, buffer_u8, connect_id)
            //write msg_id
            buffer_write(buff, buffer_s8, CLIENT_CONNECT)
    
            //send this to the server
            var message = network_send_udp(udp_client, global.connectip, port, buff, buffer_tell(buff));
			scr_log_send_udp_raw(client_messages_log, connect_id, CLIENT_CONNECT)
			
            if message < 0{ //network_send_udp returns number less than zero if message fails
                if not instance_exists(obj_input_message){
	                //if we can't connect, show and error and restart... could be more graceful :)
	                with (instance_create_layer(room_width/2, room_height/2, "lay_networking", obj_input_message)){
	                    prompt = "ERROR: Can not connect to server";
	                    ds_list_add(actions, "backOnlineLobby");
	                    ds_list_add(actionTitles, "Back");
	                }
                }
            }
            
            //lower connect buffer
            connect_udp_tries--;
            }
        else{
            //time for connect ran out
            if not instance_exists(obj_input_message){
	            with (instance_create_layer(room_width/2, room_height/2, "lay_networking", obj_input_message)){
	                prompt = "ERROR: UDP connection time ran out";
	                ds_list_add(actions, "backOnlineLobby");
	                ds_list_add(actionTitles, "Back");
                }
            }
        }
        
        #endregion
        break;
    case(NETWORK_LOGIN):
		#region Login 
        
        #endregion
        break;
    case(NETWORK_PLAY):
		#region Game is running
		//all inputs will be sent when handled in local obj_player
		
		//communication turns handled in End Step
		#endregion
        break;
}

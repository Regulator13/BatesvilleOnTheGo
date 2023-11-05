/// @description  Draw server debug information
if (server_debug) {
    // set draw offset
    var drawo = 0
	// y offset
    var yo = 20
    
    // Connected players
	var _count = ds_list_size(active_connect_ids)
	
    // draw background
	draw_set_color(c_dkgray)
    draw_set_alpha(0.75)
    draw_rectangle(0, 0, 500, (_count*5 + 4 + 1)*yo, false)
	draw_set_alpha(1)
    
    // setup drawing
    draw_set_halign(fa_left)
    draw_set_font(fnt_command)
    draw_set_color(c_red)
    
    // draw the amount of players
	draw_text(10, 10 + yo*drawo++, "Server External IP: " + external_ip)
	draw_text(10, 10 + yo*drawo++, "Server UDP Reliable Socket ID: " + string(udp_server[SOCKET_RELIABLE]) + ", Port: " + string(udp_port[SOCKET_RELIABLE]))
	draw_text(10, 10 + yo*drawo++, "Server UDP Regular Socket ID: " + string(udp_server[SOCKET_REGULAR]) + ", Port: " + string(udp_port[SOCKET_REGULAR]))
	draw_text(10, 10 + yo*drawo++, string_hash_to_newline("Active players: " + string(_count)))
    
	if _count == 0{
		//Warning
		draw_text(10, 10 + yo*drawo++, "No clients active!")
	}
	else{
	    for (var i=0; i<_count; i++){
			// obj_connected_client instances
			var Connected_client = Connected_clients[? active_connect_ids[| i]]
			
			draw_text(10, 10 + yo*drawo++, "---------------------------------------------------------")
			draw_text(10, 10 + yo*drawo++, "Connect ID: " + string(Connected_client.connect_id))
			
			var TCP_message = ds_queue_head(Connected_client.messages_out)

	        draw_text(10, 10 + yo*drawo, string_hash_to_newline(string(Connected_client.ip)))
	        draw_text(128, 10 + yo*drawo, "RTT: " + string(Connected_client.RTT) + " milliseconds")
			if not is_undefined(TCP_message){
				draw_text(256, 10 + yo*drawo, scr_network_state_to_string(TCP_message))
			}
	        if (Connected_client.alarm[SOCKET_REGULAR] < Connected_client.drop_wait[SOCKET_REGULAR]-2){
	            draw_text(400, 10 + yo*drawo, "Drop: " + string(Connected_client.alarm[SOCKET_REGULAR]))
	        }

	        drawo++
	        draw_text(10, 10 + yo*drawo, string_hash_to_newline("UDP Reliable Port: " + string(Connected_client.udp_port[SOCKET_RELIABLE])))
			draw_text(256, 10 + yo*drawo, string_hash_to_newline("UDP Regular Port: " + string(Connected_client.udp_port[SOCKET_REGULAR])))
	        drawo++
			draw_text(10, 10 + yo*drawo, string_hash_to_newline("Message Success: " + string(Connected_client.message_success)))
	        draw_text(256, 10 + yo*drawo, string_hash_to_newline("Sequence Out: " + string(Connected_client.udp_sequence_out)))

	        drawo++
	    }
	}
}


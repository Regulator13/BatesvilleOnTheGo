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
	draw_text(10, 10 + yo*drawo++, "Server UDP Reliable Socket ID: " + string(tcp_server) + ", Port: " + string(TCP_PORT))
	draw_text(10, 10 + yo*drawo++, string_hash_to_newline("Active players: " + string(_count)))
    
	if _count == 0{
		//Warning
		draw_text(10, 10 + yo*drawo++, "No clients active!")
	}
	else{
	    for (var i=0; i<_count; i++){
			// obj_connected_client instances
			var Connected_hybrid_client = Connected_hybrid_clients[? active_connect_ids[| i]]
			
			draw_text(10, 10 + yo*drawo++, "---------------------------------------------------------")
			draw_text(10, 10 + yo*drawo++, "Connect ID: " + string(Connected_hybrid_client.connect_id))
			
			var TCP_message = ds_queue_head(Connected_hybrid_client.messages_out)

	        draw_text(10, 10 + yo*drawo, string_hash_to_newline(string(Connected_hybrid_client.ip)))
			if not is_undefined(TCP_message){
				draw_text(256, 10 + yo*drawo, scr_network_state_to_string(TCP_message))
			}
	        if (Connected_hybrid_client.alarm[SOCKET_REGULAR] < Connected_hybrid_client.drop_wait[SOCKET_REGULAR]-2){
	            draw_text(400, 10 + yo*drawo, "Drop: " + string(Connected_hybrid_client.alarm[SOCKET_REGULAR]))
	        }

	        drawo++
	        draw_text(10, 10 + yo*drawo, string_hash_to_newline("TCP Socket: " + string(Connected_hybrid_client.tcp_socket)))
	        drawo++
			draw_text(10, 10 + yo*drawo, string_hash_to_newline("Message Success: " + string(Connected_hybrid_client.message_success)))

	        drawo++
	    }
	}
}


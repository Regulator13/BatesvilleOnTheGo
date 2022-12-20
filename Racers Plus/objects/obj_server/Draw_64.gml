/// @description Draw server debug information
if (serverDebug) {
    // setup drawing
    draw_set_color(c_dkgray);
    draw_set_alpha(0.8);
    
    // set draw offset
    var drawOffset = 0;
    var yOffset = 20;
	
	//get the amount of active players
    var network_player_count = ds_list_size(active_connect_ids)
    
    // draw background
    draw_rectangle(0, 0, 500, (network_player_count*7 + 5)*yOffset, false);
    
    // setup drawing
    draw_set_halign(fa_left);
    draw_set_font(fnt_basic);
    draw_set_color(c_red);
    
    // draw the amount of players
	draw_text(10, 10, string_hash_to_newline("SERVER DEBUG: "))
    draw_text(10, 30 + yOffset*drawOffset++, "Active connect_ids: " + string(network_player_count))

    draw_text(10, 30 + yOffset*drawOffset++, "TCP Server " + string(tcp_server) + " UDP Server: " + string(udp_server))
	
	//skip a line
	drawOffset++
	if network_player_count == 0{
		//Warning
		draw_text(10, 30+yOffset*drawOffset++, "No clients in connected!");
	}
	else{
		draw_text(10, 30+yOffset*drawOffset++, "Client info:");
		
	    for (var i = 0; i < network_player_count; i++) {
			//get the network player
			var Network_player = ds_map_find_value(Network_players, active_connect_ids[| i])
			
			var s = 20
			var si = 0
			draw_text(10, 30+(si++)*s+yOffset*drawOffset, "Client connect_id: " + string(Network_player.connect_id) + " Team: " + string(Network_player.team))
			
	        // draw RTT
			if Network_player.extended{
				draw_text(10, 30+(si++)*s+yOffset*drawOffset, "This player extends off another client")
				drawOffset += 3
			}
			else{
		        draw_text(10, 30+(si++)*s+yOffset*drawOffset, Network_player.ip)
		        draw_text(10, 30+si*s+yOffset*drawOffset, "RTT: " + string(Network_player.RTT) + " Min millipf: " + string(Network_player.min_millipf))
		        if (Network_player.alarm[0] < Network_player.dropBuffer-2) {
		            draw_text(400, 30+si*s+yOffset*drawOffset, string_hash_to_newline(string(Network_player.alarm[0])));
		            }
		        // increment drawOffset
		        drawOffset++;
		        //draw_text(10, 30+(si++)*s+yOffset*drawOffset, string_hash_to_newline());
		        //draw_text(10, 30+(si++)*s+yOffset*drawOffset, string_hash_to_newline("Message Success: " + string(Network_player.messageSuccess)));
		        draw_text(10, 30+(si++)*s+yOffset*drawOffset, string_hash_to_newline("UDP Last Sequence Out: " + string(Network_player.udp_sequence_out)));
		        // increment drawOffset
		        drawOffset += ++si;
			}
	    }
	}
    
    // reset alpha
    draw_set_alpha(1);
}


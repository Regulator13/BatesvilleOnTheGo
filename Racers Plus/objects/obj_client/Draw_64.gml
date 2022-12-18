/// @description  draw client debug information
if (clientDebug) {
	var dx = 500
    // setup drawing
    draw_set_color(c_dkgray);
    draw_set_alpha(0.8);
    
    // set draw offset
    var drawOffset = 0;
    var yOffset = 20;
    var count = 11;
    
    // draw background
    draw_rectangle(dx, 0, dx + 500, count*yOffset+50+10, false);
    
    // setup drawing
    draw_set_halign(fa_left);
    draw_set_font(fnt_basic);
    draw_set_color(c_red);
    
    // draw client informtion
    draw_text(dx + 10, 10, string_hash_to_newline("CLIENT DEBUG"));
    draw_text(dx + 10, 30+yOffset*drawOffset++, string_hash_to_newline("Server Message Info:"));

    draw_text(dx + 10, 30+yOffset*drawOffset++, string_hash_to_newline("Server IP: " + string(serverIP)));
    draw_text(dx + 10, 30+yOffset*drawOffset++, "TCP socket " + string(tcp_client) + " UDP socket " + string(udp_client))
    draw_text(dx + 10, 30+yOffset*drawOffset++, string_hash_to_newline("Sequence In: " + string(sequenceIn) + " msgID In: " + scr_msg_id_to_string(msgIDin)))
    drawOffset++;// skip a space
    draw_text(dx + 10, 30+yOffset*drawOffset++, string_hash_to_newline("Client State Info:"));
	draw_text(dx + 10, 30+yOffset*drawOffset++, string_hash_to_newline("Connect ID: " + string(connect_id)));
    //draw_text(dx + 10, 30+yOffset*drawOffset++, string_hash_to_newline("TCP Client Socket: " + string(tcp_client)));
    draw_text(dx + 10, 30+yOffset*drawOffset++, string_hash_to_newline("Network State: " + scr_network_state_to_string(network_state)));
	draw_text(dx + 10, 30+yOffset*drawOffset++, "Sending IP: " + string(global.connectip) + " Sending Port: " + string(port))
	draw_text(dx + 10, 30+yOffset*drawOffset++, "Actual FPS Average: " + scr_string_padded(average_actual_fps, 2) + " Maximum: " + scr_string_padded(maximum_actual_fps, 2))
	draw_text(dx + 10, 30+yOffset*drawOffset++, "Game Speed: " +  + scr_string_padded(game_get_speed(gamespeed_fps), 2)+ " Real FPS: " + string(total_real_fps/count_real_fps))
    
    // reset alpha
    draw_set_alpha(1);
}


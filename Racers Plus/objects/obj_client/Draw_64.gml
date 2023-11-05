/// @description  draw client debug information
if (client_debug) {
    // set draw offset
    var drawOffset = 0
    var yo = 20
    var count = 12
    
    // draw background
	draw_set_color(c_dkgray)
    draw_set_alpha(0.75)
    draw_rectangle(0, 0, 500, count*yo+30+10, false)
	draw_set_alpha(1)
    
    // setup drawing
    draw_set_halign(fa_left)
    draw_set_font(fnt_menu)
    draw_set_color(c_red)
    
    // draw client informtion
    draw_text(10, 10, string_hash_to_newline("CLIENT DEBUG"))
    draw_text(10, 30 + yo*drawOffset++, string_hash_to_newline("Server Message Info:"))
    draw_text(10, 30 + yo*drawOffset++, string_hash_to_newline("Server IP: " + string(server_ip)))
	draw_text(10, 30 + yo*drawOffset++, string_hash_to_newline("Server UDP Port: " + string(server_udp_port)))
    draw_text(10, 30 + yo*drawOffset++, string_hash_to_newline("Sequence In: " + string(last_sequence_received)))
    draw_text(10, 30 + yo*drawOffset++, string_hash_to_newline("Message ID In: " + scr_msg_id_to_string(last_msg_id_received)))
    drawOffset++// skip a space
    draw_text(10, 30 + yo*drawOffset++, string_hash_to_newline("Client " + string(connect_id) + " State Info:"))
	draw_text(10, 30 + yo*drawOffset++, string_hash_to_newline("Client UDP Socket ID: " + string(udp_client)))
	draw_text(10, 30 + yo*drawOffset++, string_hash_to_newline("RTT: " + string(RTT)) + " milliseconds")
    draw_text(10, 30 + yo*drawOffset++, string_hash_to_newline("Network State: " + scr_network_state_to_string(network_state)))
	draw_text(10, 30 + yo*drawOffset++, "")
}


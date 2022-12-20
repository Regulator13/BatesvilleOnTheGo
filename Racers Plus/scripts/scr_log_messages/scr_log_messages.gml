/// @function scr_log_send_communication_turn(file)
/// @description joins a client or removes them
/// @param Client | id of the client's obj_network_player on the server
//  Returns null
function scr_log_send_tcp_raw(file, conn_id, msg_id){
	if file != -1{
		var record = "RAW TCP Send " + scr_msg_id_to_string(msg_id) + " for " + scr_string_padded(conn_id, 2)
		file_text_write_string(file, record)
		//write new line after each turn
		file_text_writeln(file)
	}
}

function scr_log_send_udp_raw(file, conn_id, msg_id_or_sequence){
	if file != -1{
		var record = "RAW UDP Send " + scr_string_padded(msg_id_or_sequence, 3) + " for " + scr_string_padded(conn_id, 2)
		file_text_write_string(file, record)
		//write new line after each turn
		file_text_writeln(file)
	}
}

function scr_log_send_communication_turn(file, conn_id, buff){
	if file != -1{
		buffer_seek(buff, buffer_seek_start, 4)
		var comm_turn_speed = buffer_read(buff, buffer_u8)
		var comm_turn_length = buffer_read(buff, buffer_u8)
		var record = "Sending turn " + scr_string_padded(communication_turn, 3) + " to " + scr_string_padded(conn_id, 2) + " " + scr_string_padded(comm_turn_length, 2) + "@" + scr_string_padded(comm_turn_speed, 3)
		file_text_write_string(file, record)
		//write new line after each turn
		file_text_writeln(file)
	}
}

function scr_log_send_wait(file, current_communication_turn){
	if file != -1{
		var record = "Sending wait " + scr_string_padded(current_communication_turn, 3)
		file_text_write_string(file, record)
		//write new line after each turn
		file_text_writeln(file)
	}
}

function scr_log_send_ping(file){
	if file != -1{
		var record = "Sending ping while on " + scr_string_padded(communication_turn, 3)
		file_text_write_string(file, record)
		//write new line after each turn
		file_text_writeln(file)
	}
}


function scr_log_receive_tcp_raw(file, conn_id, msg_id){
	if file != -1{
		var record = "RAW TCP Received " + scr_msg_id_to_string(msg_id) + " for " + scr_string_padded(conn_id, 2)
		file_text_write_string(file, record)
		//write new line after each turn
		file_text_writeln(file)
	}
}

/// @function scr_log_send_communication_turn(file)
/// @description joins a client or removes them
/// @param Client | id of the client's obj_network_player on the server
//  Returns null
function scr_log_receive_communication_turn(file, comm_turn){
	if file != -1{
		var record = "Received turn " + scr_string_padded(comm_turn, 3) + " " + scr_string_padded(ds_queue_tail(communication_turn_length), 2) + "@" + scr_string_padded(ds_queue_tail(communication_turn_speed), 3)
		file_text_write_string(file, record)
		//write new line after each turn
		file_text_writeln(file)
	}
}

function scr_log_receive_wait(file, comm_turn){
	if file != -1{
		var record = "Received wait, client on " + scr_string_padded(comm_turn, 3) + " while server is on " + scr_string_padded(communication_turn, 3)
		file_text_write_string(file, record)
		//write new line after each turn
		file_text_writeln(file)
	}
}

function scr_log_receive_ping(file, connect_id, rtt){
	if file != -1{
		var record = "Received ping from " + scr_string_padded(connect_id, 2) + " while on " + scr_string_padded(communication_turn, 3) + " " + scr_string_padded(rtt, 6)
		file_text_write_string(file, record)
		//write new line after each turn
		file_text_writeln(file)
	}
}

function scr_log_reply_ping(file, avg_fps){
	if file != -1{
		var record = "Sending ping while on " + scr_string_padded(communication_turn, 3) + " avg FPS: " + string(avg_fps)
		file_text_write_string(file, record)
		//write new line after each turn
		file_text_writeln(file)
	}
}
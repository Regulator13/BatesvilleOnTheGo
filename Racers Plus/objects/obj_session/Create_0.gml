/// @description Initialize networking

global.online = true;	//set menu to treat game as online
global.Server = noone
global.connectip = "127.0.0.1"
global.Networking = self
global.have_server = false	//set in obj_server

//delta timing to account for varying game speeds
target_frame_time = 1/60
actual_frame_time = delta_time/1000000
global.frame_time_multiplier = actual_frame_time/target_frame_time

//local servers
serverlist = ds_list_create();
servernames = ds_list_create();
server_refresh = ds_list_create();

//create a server to listen on our broadcast port....
broadcast_server = network_create_server(network_socket_udp, BROADCAST_PORT, 48);

//set up menu
if os_browser == browser_not_a_browser{
	var _y = room_height-90
	Direct_IP = scr_create_text_box(room_width/2, _y, id, "Direct IP", "Enter Direct IP", "", true, 15, fa_center, fa_middle)
	Name_input = scr_create_text_box(room_width/2, room_height/2, id, "Player Name", "Newbius", "", true, 15, fa_center, fa_middle)
}
else{
	form = noone
	// Set in scr_load_player()
	default_name = ""
	default_ip = ""
}

//try to load player name
scr_load_player();

//auto refresh
alarm[2] = 120


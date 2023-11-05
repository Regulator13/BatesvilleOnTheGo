/// @description Initialize networking

global.have_server = false
global.online = true

serverlist = ds_list_create();
servernames = ds_list_create();

// Create a socket and listen on our broadcast port....
broadcast_socket = network_create_socket_ext(network_socket_udp, BROADCAST_PORT)

//set up menu
if os_browser == browser_not_a_browser{
	/// Module Integration - Menu
	Direct_ip_box = menu_create_text_box(room_width/2, room_height - 96, "Direct IP", "Enter Direct IP")
	Name_box = menu_create_text_box(room_width/2, room_height - 32, "Player Name", "Newbius")
}
else{
	form = noone
	// Set in scr_load_player()
	default_name = ""
	default_ip = ""
}

//try to load player name
scr_load_player()

//auto refresh
alarm[2] = 120


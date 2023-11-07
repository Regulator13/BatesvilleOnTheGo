/// @description Initialize networking

global.online = true

serverlist = ds_list_create();
servernames = ds_list_create();

// Set in scr_load_player()
default_name = ""
default_ip = ""

//try to load player name
scr_load_player()

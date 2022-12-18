/// @description Prepare controller instance

// Automatically delete if going through networking menus
if variable_global_get("online"){
	instance_destroy()
	exit
}

global.online = false
// obj_server
global.have_server = false
var Menu = instance_create_layer(0, 0, "lay_instances", obj_menu)
Menu.state = STATE_GAME
var Control = instance_create_layer(0, 0, "lay_instances", obj_game_control)
var Player = instance_create_layer(0, 0, "lay_instances", obj_player)
Player.local = true
Player.block_amount = 10
Player.player_color = 1




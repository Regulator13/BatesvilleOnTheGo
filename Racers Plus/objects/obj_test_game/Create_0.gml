/// @description Replace obj_menu

// Automatically delete if going through networking menus
if variable_global_get("online"){
	instance_destroy()
	exit
}

global.have_server = false

var Menu = instance_create_layer(0, 0, "lay_instances", obj_menu)
Menu.state = STATE_GAME
global.online = false
var Control = instance_create_layer(0, 0, "lay_instances", obj_game_control)
var Player = instance_create_layer(0, 0, "lay_instances", obj_player)
Player.local = true
Player.player_color = 1
Player.team = 1

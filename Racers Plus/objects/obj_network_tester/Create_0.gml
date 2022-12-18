/// @description Carry out commands to test the network
if global.have_server alarm[0] = 5

var conn_id = 1
var Player = obj_client.Network_players[? conn_id]
if not is_undefined(Player){
	if not global.have_server or (global.have_server and obj_server.Network_players[? conn_id].extended == true){
		alarm[1] = 5
	}
}

player_1_inputs = 1
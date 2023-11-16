/// @description  Direct connect or Phame connect
/// Module Integration - Menu
// Switch menu to the lobby
// This will destroy all menus buttons including the two text boxes

// Set in Draw event by HTML
var name = default_name
var ip = default_ip

// Create  client
var Client = instance_create_layer(0, 0, "lay_instances", obj_hybrid_client)
Client.player_name = name
Client.server_ip = ip
	
with Client event_user(0)

scr_save_player(name, ip)

// client takes care of all networking now
instance_destroy()

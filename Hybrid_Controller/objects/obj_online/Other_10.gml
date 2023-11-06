/// @description  Direct connect or Phame connect
/// Module Integration - Menu
// Switch menu to the lobby
// This will destroy all menus buttons including the two text boxes

// Set in Draw event by HTML
var name = default_name
var ip = default_ip

// Create  client
var Client = instance_create_layer(0, 0, "lay_instances", obj_client)
Client.player_name = name
obj_client.server_ip = ip
	
with obj_client event_user(0)

scr_save_player(name, ip)

/// Module Integration - Menu
// Create client before state switch
menu_state_switch(STATE_ONLINE, STATE_LOBBY)

// client takes care of all networking now
instance_destroy()

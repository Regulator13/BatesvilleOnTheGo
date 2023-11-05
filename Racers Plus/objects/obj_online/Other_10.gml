/// @description  Direct connect or Phame connect
/// Module Integration - Menu
// Switch menu to the lobby
// This will destroy all menus buttons including the two text boxes
if os_browser == browser_not_a_browser{
	var name = Name_box.text
	var ip = Direct_ip_box.text
}
else {
	// Set in Draw event by HTML
	var name = default_name
	var ip = default_ip
}

// Create  client
var Client = instance_create_layer(0, 0, "lay_instances", obj_client)
Client.player_name = name

scr_save_player(name, ip)

/// Module Integration - Menu
// Create client before state switch
menu_state_switch(STATE_ONLINE, STATE_LOBBY)

// client takes care of all networking now
instance_destroy()

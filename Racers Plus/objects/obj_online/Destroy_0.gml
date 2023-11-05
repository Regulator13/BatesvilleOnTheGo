/// @description  destroy created objects

// destroy ds_lists
ds_list_destroy(serverlist)
ds_list_destroy(servernames)

/// Module Integration - Menu
// As these are now a part of obj_menu.Buttons
// they will be destroyed with the menu change
//instance_destroy(Name_box)
//instance_destroy(Direct_ip_box)

// destroy broadcast
network_destroy(broadcast_socket)

/// @description Replace obj_menu

// Automatically delete if going through networking menus
if variable_global_get("online"){
	instance_destroy()
	exit
}

global.have_server = false
global.online = false
global.production = false

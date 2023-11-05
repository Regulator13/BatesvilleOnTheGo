/// @description Initiate controls

// Array of virtual controllers accesible throughout the game
// Craeted with module interface
controllers = array_create(0)

controls_declare_functions()
controls_declare_interface_functions()
set_default_controllers()
	save_controllers()
if file_exists("controllers.json") {
	load_controllers()
}
else {
	set_default_controllers()
	save_controllers()
}
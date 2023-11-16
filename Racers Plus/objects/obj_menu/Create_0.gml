/// @description Initialize menus

menu_declare_functions()
menu_declare_interface_functions()

state = STATE_MAIN
// State history in order visited for universal back button
state_queue = ds_stack_create()

Buttons = ds_list_create()
selected_button_index = 0

global.hybrid_online = false
global.have_hybrid_server = false
global.paused = false

main_player_controller = 5
instance_create_layer(0, 0, "lay_instances", obj_controls)
/// @description Press Button
if alarm[0] <= 0{
	//create input box
	var Button = instance_create_layer(room_width/2, room_height/2, "lay_instances", obj_input_control);
	Button.control = control
	Button.controller = controller
	Button.player = obj_menu.main_player_controller;
	Button.Source = self;
}
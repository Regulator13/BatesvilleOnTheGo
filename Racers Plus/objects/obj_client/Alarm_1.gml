/// @description Create input message
var inst = instance_create_layer(room_width/2, room_height/2, "lay_networking", obj_input_message)
with inst{
	prompt = "ERROR: Connection time ran out";
	ds_list_add(actions, "backOnlineLobby");
	ds_list_add(actionTitles, "Back");
}

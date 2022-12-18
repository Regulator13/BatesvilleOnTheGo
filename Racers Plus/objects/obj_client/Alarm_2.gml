/// @description Update server
if instance_exists(Player){
	scr_client_send_update(obj_client.connect_id, Player)
}
else{
	/// DEBUG
	show_debug_message("Warning! Cannot send update: Player does not exist")
}

alarm[2] = 1
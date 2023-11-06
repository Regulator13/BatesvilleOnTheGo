/// @description These children all require server approval to interact with
///Networking
if global.online{
	interactable_id = global.next_interactable_id++
	// TODO: Reuse interactable ids, current limit is 65,536 ids
	if interactable_id > 65535{
		show_message("Warning: Maximum interactable ID reached.")
		instance_destroy()
		exit
	}
	
	interactor_id = -1
	ds_list_add(global.Interactables, self)
}
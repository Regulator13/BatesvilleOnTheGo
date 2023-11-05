/// @description Destroy data structures
ds_list_destroy(global.Interactables)

repeat(ds_list_size(Groups)){
	instance_destroy(Groups[| 0])
	ds_list_delete(Groups, 0)
}
ds_list_destroy(Groups)

ds_map_destroy(Group_ids)

ds_map_destroy(lobby_slot_map)
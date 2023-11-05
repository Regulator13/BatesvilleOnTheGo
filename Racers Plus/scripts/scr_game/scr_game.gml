function game_declare_functions(){
	function remove_group(Group){
		var index = ds_list_find_index(Groups, Group)
	
		// Sections is a parrallel list with an offset of one index for Soldiers
		ds_list_delete(Groups, index)
		ds_map_delete(Group_ids, Group.group_id)
		instance_destroy(Group)
	}
	
	function read_group(buff){
		var Group = instance_create_layer(0, 0, "lay_instances", obj_group)
		Group.read_from_buffer(buff)
		ds_list_add(Groups, Group)
		ds_map_add(Group_ids, Group.group_id, Group)
	}
}
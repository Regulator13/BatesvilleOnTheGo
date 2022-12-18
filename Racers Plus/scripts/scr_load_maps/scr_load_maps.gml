/// @function                 load_maps();
/// @description              Loads possible maps into list
function load_maps(){
	var loaded_maps = []
	
	var map = instance_create_layer(0, 0, LAY, obj_map)
	
	map.spawn_amount = 2
	map.room_index = rm_downtown
	map.options[0] = 0
	
	loaded_maps[0] = map
	
	return loaded_maps
}
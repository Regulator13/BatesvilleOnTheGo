function load_maps(){
	var loaded_maps = []
	var i = 0
	
	var map_file = file_find_first(working_directory + "map_*.ini", 0)
	while map_file != ""{
		//load map
		loaded_maps[i] = load_map(string_copy(map_file, 0, string_length(map_file) - 4), i)
		map_file = file_find_next()
		i++
	}
	
	return loaded_maps
}

function load_map(filename, index){
	var map = instance_create_layer(0, 0, "lay_instances", obj_map)
	ini_open(filename + ".ini")
	map.title = ini_read_string("attributes", "title", "")
	map.map_width = ini_read_real("attributes", "width", -1)
	map.map_height = ini_read_real("attributes", "height", -1)
	map.description = ini_read_string("attributes", "description", "")
	map.sprite_index = sprite_add(filename + ".png", 1, false, false, 0, 0)
	map.room_index = asset_get_index(ini_read_string("attributes", "room_index", ""))
	map.setups = ini_read_real("settings", "setups", 1)
	map.index = index
	ini_close()
	return map
}
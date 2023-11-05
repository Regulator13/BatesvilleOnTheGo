/// @description Get external IP
if (ds_map_find_value(async_load, "id") == h_get_ip){
	if (ds_map_find_value(async_load, "status") == 0){
	    external_ip = ds_map_find_value(async_load, "result")
	}
}
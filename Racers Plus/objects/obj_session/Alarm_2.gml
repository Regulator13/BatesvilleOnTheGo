/// @description Auto refresh
var servers = ds_list_size(server_refresh)
for (var i=0; i<servers; i++){
	if !server_refresh[| i]{
		ds_list_delete(serverlist, i)
		ds_list_delete(servernames, i)
		ds_list_delete(server_refresh, i)
	}
	else{
		ds_list_replace(server_refresh, i, server_refresh[| i]-1)
	}
}
alarm[2] = 120

/// @description Destroy data structures
instance_destroy(Player)

ds_queue_destroy(messages_out)

//remove from lists
var i = ds_list_find_index(obj_server.active_connect_ids, connect_id)
ds_list_delete(obj_server.active_connect_ids, i)
var i = ds_list_find_index(obj_server.client_connect_ids, connect_id)
ds_list_delete(obj_server.client_connect_ids, i)
ds_map_delete(obj_server.Connected_clients, connect_id)
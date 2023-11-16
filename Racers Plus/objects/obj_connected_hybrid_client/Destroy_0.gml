/// @description Destroy data structures
instance_destroy(Player)

ds_queue_destroy(messages_out)

//remove from lists
var i = ds_list_find_index(obj_hybrid_server.active_connect_ids, connect_id)
ds_list_delete(obj_hybrid_server.active_connect_ids, i)
var i = ds_list_find_index(obj_hybrid_server.client_connect_ids, connect_id)
ds_list_delete(obj_hybrid_server.client_connect_ids, i)
ds_map_delete(obj_hybrid_server.Connected_hybrid_clients, connect_id)
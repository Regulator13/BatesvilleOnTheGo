/// @description  Drop player

// This object only exists on the server end
// Remove from authoritative list
var index = ds_list_find_index(obj_hybrid_server.active_connect_ids, connect_id)
ds_list_delete(obj_hybrid_server.active_connect_ids, index)
ds_map_delete(obj_hybrid_server.Connected_hybrid_clients, connect_id)

// Destory self
instance_destroy()


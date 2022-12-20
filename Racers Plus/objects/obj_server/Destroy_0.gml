/// @description Close server

global.have_server = false

//destroy network
network_destroy(udp_server)
network_destroy(tcp_server)
network_destroy(broadcast_server)

//destroy buffers to avoid memory leaks as restarting the game will not clear or delete a buffer
buffer_delete(broadcast_buffer)
buffer_delete(game_buffer)
buffer_delete(confirmBuffer)

#region Destroy any client persistent objects
//works to destroy all instances of the object
instance_destroy(obj_network_player)
#endregion

//destroy lists
ds_list_destroy(active_connect_ids)
ds_list_destroy(client_connect_ids)

//destroy maps
ds_map_destroy(Network_players)

//load server settings
ini_open("server.ini")
ini_write_real("performance", "max_millipf", max_millipf)
ini_write_real("performance", "seconds_between_pings", seconds_between_pings)
ini_write_real("performance", "turns_per_set", turns_per_set)
ini_close()
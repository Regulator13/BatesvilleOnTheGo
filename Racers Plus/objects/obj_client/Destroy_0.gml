/// @description Close client

//destroy network
network_destroy(udp_client)
network_destroy(tcp_client)

//destroy buffers
buffer_delete(buff)

//destory persistent obj_players
instance_destroy(obj_player)

//destroy lists
ds_map_destroy(Network_players)
ds_list_destroy(active_connect_ids)
ds_list_destroy(previous_actual_fps)
ds_list_destroy(previous_real_fps)


//reset game speed
game_set_speed(60, gamespeed_fps)

//close debug log
if debug_log != -1 file_text_close(debug_log)
if client_messages_log != -1 file_text_close(client_messages_log)
if client_speed_log != -1 file_text_close(client_speed_log)

draw_enable_drawevent(true)

#region Score Networking
ds_list_destroy(Teams)
#endregion
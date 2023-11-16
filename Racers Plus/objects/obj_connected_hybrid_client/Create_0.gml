/// @description Server-side player tracker

Player = instance_create_layer(x, y, "lay_instances", obj_player)
Player.Parent = self

#region Networking
// Connection details of connecting client used to send messages back
ip = 0
tcp_socket = -1
// Simple messages from the server to send out
messages_out = ds_queue_create()

// Assuming NAT traversal is involved (UDP Hole Punching over the Internet)
// UDP Idle Timeouts need to be accounted for
// According to Bryan Ford (https://bford.info/pub/net/p2pnat/index.html)
// these can be as low as 20 seconds, so ping before that

drop_wait = 20*game_get_speed(gamespeed_fps)
alarm[0] = drop_wait
#endregion

#region Debug

// message_success - whether the message was succesful sent
message_success = -1;
#endregion

/// @description Server-side player tracker

Player = instance_create_layer(x, y, "lay_instances", obj_authoritative_player)
Player.Parent = self

// Whether this player extends off another who has the client
extended = false
// Reset in obj_menu when lobby starts
spectating = false

#region Networking
// Connection details of connecting client used to send messages back
ip = 0
tcp_socket = -1
udp_port = -1
// Simple messages from the server to send out
messages_out = ds_queue_create()
// UDP sequences
udp_sequence_out = 0
// RTT - store the current round trip time for messages
// Use -1 to indicate no actual data yet
RTT = -1

// Assuming NAT traversal is involved (UDP Hole Punching over the Internet)
// UDP Idle Timeouts need to be accounted for
// According to Bryan Ford (https://bford.info/pub/net/p2pnat/index.html)
// these can be as low as 20 seconds, so ping before that

drop_wait = 20*game_get_speed(gamespeed_fps)
alarm[0] = drop_wait
#endregion

#region debug

// message_success - whether the message was succesful sent
message_success = -1;
#endregion

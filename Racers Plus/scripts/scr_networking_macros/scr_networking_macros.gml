#macro BROADCAST_RATE 60

#macro TCP_PORT 6513
#macro UDP_PORT 6510
#macro BROADCAST_PORT 6511


//client side network states
#macro NETWORK_TCP_CONNECT 0
#macro NETWORK_UDP_CONNECT 4
#macro NETWORK_LOGIN 2
#macro NETWORK_LOBBY 3
#macro NETWORK_GAMECONFIG 5
#macro NETWORK_SCORE 6
#macro NETWORK_PLAY 1

#macro SEQUENCE_MAX 255
// Server game message identifiers
#macro PING 20

#macro CLIENT_CONNECT 5
#macro CLIENT_LOGIN 3
#macro CLIENT_PLAY 0
#macro CLIENT_PING 7
//numbers cannot duplicate client messages, because client-server cannot differentiate via ports
#macro SERVER_CONNECT 6
#macro SERVER_LOGIN 4
#macro SERVER_PLAY 2
#macro SERVER_PING 8
#macro SERVER_STATESWITCH 10	


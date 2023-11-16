/// @description Close client

// Destroy network
network_destroy(tcp_client)

// Destroy all created persistent networking objects
instance_destroy(Player)

// Destroy buffers after instances so they can still attempt to send any last images
// e.g. READY_UP when obj_character is destroyed
buffer_delete(message_buffer)

file_text_close(global.message_log)
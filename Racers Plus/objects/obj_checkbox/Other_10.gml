/// @description Perform action
switch action{
	case "client-send-ready":
		scr_client_send_input(obj_client.connect_id, READY_UP, -1, -1)
		break
}
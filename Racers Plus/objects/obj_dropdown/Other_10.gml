/// @description Perform action
switch action{
	case "client-send-color":
		var section_index = ds_list_find_index(obj_lobby.Sections, Source)
		scr_client_send_input(obj_client.connect_id, COLOR_CHANGE, section_index, field)
		break
	case "client-send-player-color":
		scr_client_send_input(obj_client.connect_id, PLAYER_COLOR_CHANGE, field, -1)
		break
	case "client-send-team":
		var section_index = ds_list_find_index(obj_lobby.Sections, Source)
		scr_client_send_input(obj_client.connect_id, TEAM_CHANGE, section_index, field)
		break
	case "client-send-map":
		scr_client_send_input(obj_client.connect_id, MAP_CHANGE, field, -1)
		break
	case "event 0":
		with Source event_user(0)
		break
}
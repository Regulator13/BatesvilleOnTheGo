/// @description Drop player if not responding
switch(obj_menu.state){
	case STATE_LOBBY:
        //just drop
		show_debug_message("Warning! Connected client dropping")
        event_user(1)
		break
    default:
		/// Module Integration - Menu
        with (instance_create_layer(room_width/2, room_height/2, "lay_networking", obj_input_message)) {
            prompt = other.Player.player_name + " is not responding (REGULAR), drop?";
            ds_list_add(actions, "dropPlayer");
            ds_list_add(actionTitles, "yes");
            ds_list_add(actions, "reset_regular_drop_buffer");
            ds_list_add(actionTitles, "no");
            Source = other;
        }
		break
}


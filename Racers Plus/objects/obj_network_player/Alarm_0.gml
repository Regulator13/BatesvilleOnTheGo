/// @description Drop player if not responding
switch global.Menu.state{
    case STATE_LOBBY:
        //just drop
		show_debug_message("obj_network_player.Alarm0 Dropping")
        //event_user(1);
		//break
    default:
        with (instance_create_layer(room_width/2, room_height/2, "lay_networking", obj_input_message)) {
            prompt = other.name + " is not responding, drop?";
            ds_list_add(actions, "dropPlayer");
            ds_list_add(actionTitles, "yes");
            ds_list_add(actions, "resetDropBuffer");
            ds_list_add(actionTitles, "no");
            Source = other;
            }
    }

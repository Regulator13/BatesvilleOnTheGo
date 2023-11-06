/// @description  Disconnect if server is not responding
/// Module Integration - Menu
with (instance_create_layer(room_width/2, room_height/2, "lay_instances", obj_input_message)) {
    prompt = "Server not responding, disconnect?";
    switch(obj_menu.state) {
        case STATE_LOBBY:
            ds_list_add(actions, "backOnlineLobby");
            break;
        case STATE_GAMECONFIG:
            ds_list_add(actions, "backOnlinePaths");
            break;
        case STATE_GAME:
            ds_list_add(actions, "backOnlineGame");
            break;
        case STATE_SCORE:
            ds_list_add(actions, "backOnlineScore");
            break;
    }
    ds_list_add(actionTitles, "yes");
    ds_list_add(actions, "resetDisconnectBuffer");
    ds_list_add(actionTitles, "no");
}


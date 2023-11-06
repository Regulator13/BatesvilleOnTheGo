/// @function scr_msg_id_to_String(msgID)
/// @description Takes the msgID contsant and returns the corresponding string
/// @param msgID
function scr_interaction_to_string(interaction) {
	switch (interaction) {
		case LOBBY_MISSION_CHANGE:
			return "LOBBY_MISSION_CHANGE"
		case LOBBY_JOIN:
			return "LOBBY_JOIN"
		case LOBBY_SECTION_ADD:
			return "LOBBY_SECTION_ADD"
		case LOBBY_ROLE_CHANGE:
			return "LOBBY_ROLE_CHANGE"
		case LOBBY_ROLE_LEAVE:
			return "LOBBY_ROLE_LEAVE"
		case LOBBY_SLOT_JOIN:
			return "LOBBY_SLOT_JOIN"
		case LOBBY_UPDATE_PLAYER:
			return "LOBBY_UPDATE_PLAYER"
		case LOBBY_INITIALIZE:
			return "LOBBY_INITIALIZE"
		case GAME_GROUP_ADD:
			return "GAME_GROUP_ADD"
		case GAME_JOIN:
			return "GAME_JOIN"
		default:
			return "Unkown Interaction"
	}
}

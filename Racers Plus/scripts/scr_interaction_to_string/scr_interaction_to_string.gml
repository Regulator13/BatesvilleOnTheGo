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
		case GAME_JOIN:
			return "GAME_JOIN"
		case GAME_UPDATE_PLAYER_TEAM:
			return "GAME_UPDATE_PLAYER_TEAM"
		case GAME_UPDATE_PLAYER_COLOR:
			return "GAME_UPDATE_PLAYER_COLOR"
		case GAME_UPDATE_PLAYER_MODEL:
			return "GAME_UPDATE_PLAYER_MODEL"
		case GAME_DRIVE_UPDATE:
			return "GAME_DRIVE_UPDATE"
		case GAME_PICKUP:
			return "GAME_PICKUP"
		default:
			return "Unkown Interaction"
	}
}

#region Action
#macro ACT_LOBBY_MISSION_CHANGE 0
#macro ACT_LOBBY_JOIN 1
#macro ACT_LOBBY_SECTION_ADD 2
#macro ACT_LOBBY_ROLE_CHANGE 3
#macro ACT_LOBBY_ROLE_LEAVE 4
#macro ACT_LOBBY_SLOT_JOIN 5
#macro ACT_LOBBY_UPDATE_PLAYER 6
#macro ACT_LOBBY_INITIALIZE 7
#macro ACT_GAME_JOIN 10
#macro ACT_GAME_UPDATE_PLAYER_TEAM 11
#macro ACT_GAME_UPDATE_PLAYER_COLOR 12
#macro ACT_GAME_UPDATE_PLAYER_MODEL 13
#macro ACT_GAME_DRIVE_UPDATE 14
#macro ACT_GAME_PICKUP 15
#endregion

/// @function scr_action_to_string(action)
/// @description Takes the action and returns the corresponding string
/// @param action
function scr_action_to_string(action) {
	switch (action) {
		case ACT_LOBBY_MISSION_CHANGE:
			return "ACT_LOBBY_MISSION_CHANGE"
		case ACT_LOBBY_JOIN:
			return "ACT_LOBBY_JOIN"
		case ACT_LOBBY_SECTION_ADD:
			return "ACT_LOBBY_SECTION_ADD"
		case ACT_LOBBY_ROLE_CHANGE:
			return "ACT_LOBBY_ROLE_CHANGE"
		case ACT_LOBBY_ROLE_LEAVE:
			return "ACT_LOBBY_ROLE_LEAVE"
		case ACT_LOBBY_SLOT_JOIN:
			return "ACT_LOBBY_SLOT_JOIN"
		case ACT_LOBBY_UPDATE_PLAYER:
			return "ACT_LOBBY_UPDATE_PLAYER"
		case ACT_LOBBY_INITIALIZE:
			return "ACT_LOBBY_INITIALIZE"
		case ACT_GAME_JOIN:
			return "ACT_GAME_JOIN"
		case ACT_GAME_UPDATE_PLAYER_TEAM:
			return "ACT_GAME_UPDATE_PLAYER_TEAM"
		case ACT_GAME_UPDATE_PLAYER_COLOR:
			return "ACT_GAME_UPDATE_PLAYER_COLOR"
		case ACT_GAME_UPDATE_PLAYER_MODEL:
			return "ACT_GAME_UPDATE_PLAYER_MODEL"
		case ACT_GAME_DRIVE_UPDATE:
			return "ACT_GAME_DRIVE_UPDATE"
		case ACT_GAME_PICKUP:
			return "ACT_GAME_PICKUP"
		default:
			return "Unkown action"
	}
}

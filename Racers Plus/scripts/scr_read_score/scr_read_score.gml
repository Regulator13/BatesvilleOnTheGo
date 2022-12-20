// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_read_score(buff){
	
	var team_amount = buffer_read(buff, buffer_u8)
	
	for (var i = 0; i < team_amount; i++;) {
		var team = buffer_read(buff, buffer_u8)
		var team_score = buffer_read(buff, buffer_u16)
		var team_color = buffer_read(buff, buffer_u8)
		
		if is_undefined(Teams[| i]) {
			Teams[| i] = new stc_team(team, team_score, team_color)
		}
		
		var Team = Teams[| i]
		Team.team = team
		Team.team_score = team_score
		Team.team_color = team_color
		ds_list_clear(Team.Players)
		
		var player_amount = buffer_read(buff, buffer_u8)
		for (var j = 0; j < player_amount; j++) {
			var player_name = buffer_read(buff, buffer_string)
			var ready_to_start = buffer_read(buff, buffer_bool)
			ds_list_add(Team.Players, new stc_player(player_name, ready_to_start))
		}
	}
}
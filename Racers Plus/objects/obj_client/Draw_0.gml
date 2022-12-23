/// @description Draw game state
switch obj_menu.state {
	case STATE_SCORE:
		var dx = 128
		var dy = 64
		var di = 0
		var s = 32
		
		draw_set_halign(fa_left)
		draw_set_valign(fa_top)
		
		var _size = ds_list_size(Teams)
		for (var i = 0; i < _size; i++){
			var Team = Teams[| i]
			// Draw team
			draw_set_color(obj_menu.color_array[Team.team_color])
			draw_rectangle(dx, dy + di*s + 1, room_width - dx, dy + di*s + s - 2, true)
			if Team.team == 0 {
				//draw_text(dx, dy + di*s, "Mountain Man")
			}
			else {
				draw_text(dx, dy + di*s, "Team " + string(Team.team))
			}
			draw_text(dx + dx*2, dy + di*s, "Score: " + string(Team.team_score))
			draw_set_color(c_white)
			di++
			
			// Draw team players
			var team_players = ds_list_size(Team.Players)
			if team_players > 0 {
				draw_rectangle(dx, dy + di*s + 1, room_width - dx, dy + (di + team_players)*s - 2, true)
				for (var j = 0; j < team_players; j++){
					var Player = Team.Players[| j]
					draw_text(dx, dy + di*s, Player.player_name)
					if Player.ready_to_start{
						draw_text(dx + dx, dy + di*s, "Ready!")
					}
					di++
				}
			}
		}
		break
}


function stc_team(_team, _score, _color) constructor {
	team = _team
	team_score = _score
	team_color = _color
	Players = ds_list_create()
}

function stc_player(_name, ready) constructor {
	player_name = _name
	ready_to_start = ready
}
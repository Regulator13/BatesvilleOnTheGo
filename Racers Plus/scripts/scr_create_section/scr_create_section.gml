
function scr_create_section(section_type, index){
	/*This function creates the lobby section instance,
	* and fills out the given properties
	*/
	var inst = instance_create_layer(0, 0, "lay_networking", obj_lobby_section)
	inst.section_type = section_type
	if section_type != NETWORK_SECTION{
		inst.Join_box = scr_create_button(obj_lobby.section_draw_start_x, 0, inst, "plain", "join-section", "+", obj_lobby.section_draw_width, obj_lobby.section_draw_height)
		if section_type == SPAWN_SECTION{
			//create input boxes for section
			//y positions will be updated with the lobby	
			//inst.Team_box = scr_create_dropdown(obj_lobby.team_draw_start, 0, inst, "team", index, "client-send-team", true, 24, 24)
			inst.team = index
			inst.Color_box = scr_create_dropdown(obj_lobby.color_draw_start, 0, inst, "color", index, "client-send-color", true, 24, 24)
		}
	}
	else{
		//set info to send over to clients
		inst.team = index
		
		// Try to set color to previously set one
		var Team = obj_menu.Teams[? inst.team]
		if not is_undefined(Team){
			inst.spawn_color = Team.team_color
		}
		else{
			inst.spawn_color = index
		}
	}
	return inst
}
/// @description Draw the lobby menu

//the lobby is broken up into slots within sections
//the default section is spectator and is where every player joins into

if global.online and global.have_server {
	draw_set_color(c_black)
	draw_set_halign(fa_middle)
	draw_set_font(fnt_large)
	draw_text(room_width/2, 2, "IP: " + obj_server.server_ip)
	
	// Joining instructions
	var dx = room_width*3/4
	var dy = 64
	var s = 48
	draw_set_color(c_red)
	draw_text(dx, dy + s*0, "Instructions")
	draw_set_color(c_black)
	draw_text(dx, dy + s*1, "Join Phame Games wifi")
	draw_text(dx, dy + s*2, "Password: phamegames")
	draw_text(dx, dy + s*3, "Visit: http://" + obj_server.server_ip)
	draw_text(dx, dy + s*4, "Click the 3 dots and then 'Add to Home Screen'")
	draw_text(dx, dy + s*5, "Open new app")
	draw_set_font(fnt_basic_small)
}

#region Draw sections
var _x = section_draw_start_x
var _y = section_draw_start_y
if instance_exists(Map){
	//draw all spawn sections first
	for (var i=0; i<Map.spawn_amount; i++){
		//draw spawn header w/o dropdown menus
		//all dropdown menus whether active for this client or not are objects
		draw_set_color(c_black)
		draw_rectangle(_x, _y, _x + section_draw_width, _y + section_draw_height, false)
		draw_set_color(c_white)
		draw_rectangle(_x, _y, _x + section_draw_width, _y + section_draw_height, true)
		draw_set_halign(fa_left)
		draw_text(_x + edge, _y + edge, "Team " + string(i + 1))
		//draw labels to the right of the input boxes
		draw_set_halign(fa_right)
		//draw_text(team_draw_start, _y + edge, "Team ")
		draw_text(color_draw_start, _y + edge, "Color ")
		//header is now complete
		_y += section_draw_height
		var _players = ds_list_size(Sections[| (i + 1)].Players)
		for (var j=0; j<_players; j++){
			//draw slots for all current players within
			draw_set_color(c_gray)
			draw_rectangle(_x, _y, _x + section_draw_width, _y + section_draw_height, false)
			draw_set_color(c_white)
			draw_rectangle(_x, _y, _x + section_draw_width, _y + section_draw_height, true)
			//draw ready status
			var Player = Sections[| (i + 1)].Players[| j]
			draw_set_halign(fa_left)
			draw_text(section_draw_width - 200, _y, "Connect ID: " + string(Player.connect_id))
			//information about player is displayed in the pertinent input box instances
			_y += section_draw_height
		}
		//add one more space for the join section button
		_y += section_draw_height
	}
}
//draw default section
draw_set_color(c_black)
draw_rectangle(_x, _y, _x + section_draw_width, _y + section_draw_height, false)
draw_set_color(c_white)
draw_rectangle(_x, _y, _x + section_draw_width, _y + section_draw_height, true)
draw_set_halign(fa_left)
draw_text(_x + edge, _y + edge, "Team 0")
_y += section_draw_height
var _players = ds_list_size(Sections[| 0].Players)
for (var i=0; i<_players; i++){
	//draw slots for all current players within
	draw_set_color(c_gray)
	draw_rectangle(_x, _y, _x + section_draw_width, _y + section_draw_height, false)
	draw_set_color(c_white)
	draw_rectangle(_x, _y, _x + section_draw_width, _y + section_draw_height, true)
	//draw ready status
	var Player = Sections[| 0].Players[| i]
	draw_text(section_draw_width - 200, _y, "Connect ID: " + string(Player.connect_id))
	//information about player is displayed in the pertinent input box instances
	_y += section_draw_height
}
#endregion
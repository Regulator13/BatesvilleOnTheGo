/// @description Draw server list

if os_browser != browser_not_a_browser{
	form = html_form(undefined, "registration-form")
	html_h1(form, "header", "Direct Connect")
	html_element(form, "1", "br")
	html_field(form, "name", "text", "Player Name", true, "", default_name)
	html_element(form, "2", "br")
	html_field(form, "ip", "text", "192.168.137.1", true, "", default_ip)
	html_submit(form, "submit", "Join", !form_is_loading, form_is_loading ? "loading" : "")
	if html_element_interaction(form){
		var values = html_form_values(form)

		player_name = values[? "name"]
		global.connectip = values[? "ip"]
		if global.connectip == ""{
			global.connectip = "192.168.137.1"
		}
		alarm[0] = 1

		ds_map_destroy(values)
	}
}
else{
	draw_set_font(fnt_basic_small);
	draw_set_color(c_white);
	draw_set_halign(fa_left);
	var sx = 128
	var sy = 400
	var fh = 50
	draw_text(sx, sy + 10,string_hash_to_newline("Select server"))
	draw_line(sx, sy + fh/2, room_width - sx, sy + fh/2)

	var yindex = sy + fh
	var count = ds_list_size(serverlist);
	for(var i=0;i<count;i++){
	    draw_text(sx, yindex, string_hash_to_newline(ds_list_find_value(serverlist, i)+"  "+ds_list_find_value(servernames, i)+"'s server") );
	    yindex+=fh;
	}
}
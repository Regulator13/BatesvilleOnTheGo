/// @description Check clicking of buttons

// get box size
var sb = 8; // side buffer
var pw;
var aw = 0; // width of actions
var ah = 0
var ro = 8; // rows
var mw = string_width(string_hash_to_newline(prompt)); // width of message
var mh = string_height(string_hash_to_newline(prompt))+sb*2

// get actions width
var s = 0; // spacing between buttons
for (var i = 0; i < ds_list_size(actions); i++;)
    aw += string_width(string_hash_to_newline(actionTitles[| i]))+sb*2+sb*s++;
	var sh = string_height(string_hash_to_newline(actionTitles[| i]))+sb*2
	if sh > ah
		ah = sh 

// set box width
if (aw > mw)
    pw = aw/2+sb;
else
    pw = mw/2+sb;
//set box height
var ph = (mh + ah)/2
	
var dx = x-aw/2;
var dy = y + ph/2 - ah/2 + ro*3;
var bh = 16;
for (var i = 0; i < ds_list_size(actions); i++;) {
	var bw = string_width(string_hash_to_newline(actionTitles[| i]))+sb*2;
    if point_in_rectangle(mouse_x, mouse_y, dx, dy-bh, dx+bw, dy+bh) {
		actionSel = i
		event_user(0)
		instance_destroy()
		break
	}
	dx += bw+sb
}

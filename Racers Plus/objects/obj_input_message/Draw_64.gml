/// @description  Draw message + action options

x = 640/2
y = 480/2

//setup drawing
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_button);
draw_set_alpha(1);

// get box size
var sb = 8; // side buffer
var pw
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

// box drawing
var b = 8
draw_set_color(c_dkgray);
draw_rectangle(x-pw, y-ph, x+pw, y+ph+b, false);
draw_set_color(c_gray);
draw_rectangle(x-pw, y-ph, x+pw, y+ph+b, true);
draw_set_color(c_white);
draw_text(x, y-ro*2, string_hash_to_newline(prompt));

// action drawing
draw_set_halign(fa_left);
var dx = x-aw/2;
var dy = y + ph/2 - ah/2 + ro*3;
var bh = 16;
for (var i = 0; i < ds_list_size(actions); i++;) {
    var bw = string_width(string_hash_to_newline(actionTitles[| i]))+sb*2;
    draw_set_color(c_dkgray);
    draw_rectangle(dx, dy-bh, dx+bw, dy+bh, false);
	
    if (i == actionSel)
        draw_set_color(c_blue);
		
    else
        draw_set_color(c_gray);
		
    draw_rectangle(dx, dy-bh, dx+bw, dy+bh, true);
    draw_set_color(c_white);
    draw_text(dx+sb, dy, string_hash_to_newline(actionTitles[| i]));
    dx += bw+sb
}

/// @description Draw input

//setup drawing
draw_set_halign(fa_center)
draw_set_valign(fa_middle)
draw_set_font(fnt_button)

// prompt
var prompt;
switch (controller.get_device(control)) {
    case DEVICE_KEYBOARD:
        prompt = "Enter Keyboard Input"
        break
		
    case DEVICE_MOUSE:
        prompt = "Enter Mouse Input"
        break
		
    default:
        prompt = "Enter Joystick Input"
        break
}

//DESCR?
var pw = string_width(string_hash_to_newline(prompt))/2+8;
var ph = 16;

draw_set_color(c_dkgray);
draw_rectangle(x-pw, y-ph, x+pw, y+ph, false);
draw_set_color(c_gray);
draw_rectangle(x-pw, y-ph, x+pw, y+ph, true);
draw_set_color(c_white);
draw_text(x, y, string_hash_to_newline(prompt));

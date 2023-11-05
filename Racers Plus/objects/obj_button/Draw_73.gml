/// @description Draw
draw_set_font(fnt_button);
draw_set_color(c_white);
draw_set_valign(fa_middle);
var bw = box_width //half button width
var bh = box_height //half button height
var ss = 48; //space for selector

switch action{
	case VALUE_BUTTON:
	case VALUEACTION_BUTTON:
		draw_set_valign(fa_top)
	    draw_set_halign(fa_right);
	    draw_text(x-ss, y, string_hash_to_newline(title));
	    draw_set_halign(fa_left);
	    draw_text(x+bw+ss, y, string_hash_to_newline(string(ds_list_find_value(values, value))));
	    draw_set_color(c_dkgray);
	    draw_rectangle(x, y, x+bw, y+bh, true);
	    draw_set_color(c_gray);
	    var sliderWidth = (bw/ds_list_size(values))
	    draw_rectangle(x+1+value*sliderWidth, y+1, x+1+value*sliderWidth+sliderWidth, y+bh-1, false);
	    draw_set_color(c_white);
		break
	case "controlButton":
	    // draw contol button
	    draw_sprite(sprite_index, image_index, x, y)
	    draw_set_halign(fa_center);
	    draw_text(x, y, string_hash_to_newline(title));
	    draw_set_halign(fa_right);
	    draw_text(x-77-48, y, string_hash_to_newline(scr_key_to_title(key)));
		break
	default:
		if sprite_exists(sprite_index){
		    draw_sprite(sprite_index, image_index, x, y)
			draw_set_halign(fa_middle)
		    draw_set_valign(fa_top)
			
		    if (title == "Default"){
				draw_text(x + sprite_width/2, y, string_hash_to_newline(action))
			}
		    else{
				draw_text(x + sprite_width/2, y, string_hash_to_newline(title))
			}
		}
		else{
			//draw plain button
			draw_set_color(c_black)
			draw_rectangle(x, y, x + box_width, y + box_height, false)
			draw_set_color(c_white)
			draw_rectangle(x, y, x + box_width, y + box_height, true)
			draw_set_halign(fa_middle)
			draw_set_valign(fa_top)
			draw_set_font(fnt_menu)
			draw_text(x + box_width/2, y, title)
		}
		break
}
/// @description Draw input box

//draw box at top left
draw_set_color(c_black)
draw_rectangle(x - border, y - border, x + box_width + border, y + box_height + border, false)
draw_set_color(c_white)
draw_rectangle(x, y, x + box_width, y + box_height, false)
if active{
	//draw dropdown
	var _x = x + box_width + 2*border
	draw_set_color(c_black)
	draw_rectangle(_x - border, y - border, _x + box_height + border, y + box_height + border, false)
	draw_set_color(c_white)
	draw_rectangle(_x, y, _x + box_height, y + box_height, false)
	draw_triangle_color(_x + edge, y + edge, _x + box_height - edge, y + edge, _x + edge + box_height/2, y + box_height - 2*edge, c_gray, c_gray, c_white, false)
}

//draw field according to type
draw_set_font(fnt_basic_small)
draw_set_color(c_black)
draw_set_halign(fa_left)
draw_set_valign(fa_top)
switch box_type{
	case "color":
		//draw color box
		draw_set_color(obj_menu.color_array[field])
		draw_rectangle(x + edge, y + edge, x + box_width - edge, y + box_height - edge, false)
		break
	case "team":
	case "text":
		draw_text(x + edge, y + edge, field)
		break
	case "spawn":
		draw_text(x + edge, y + edge, chr(ord("A") + field))
		break
	case "map":
		draw_text(x + edge, y + edge, obj_lobby.Available_maps[field].title)
		break
}

//if selected draw drop down
if selected{
	var _y = y + box_height + border*2
	var option_amount = array_length(field_options)
	//draw surronding box
	draw_set_color(c_black)
	draw_rectangle(x - border, _y - border, x + box_width + border, _y + option_amount*box_height + border, false)
	draw_set_color(c_white)
	draw_rectangle(x, _y, x + box_width, _y + option_amount*box_height, false)
	draw_set_color(c_black)
	//draw options
	for (var i=0; i<option_amount; i++){
		var _oy = _y + box_height*i
		switch box_type{
			case "color":
				//draw color box
				draw_set_color(obj_menu.color_array[field_options[i]])
				draw_rectangle(x + edge, _oy + edge, x + box_width - edge, _oy + box_height - edge, false)
				break
			case "team":
			case "text":
				draw_text(x + edge, _oy + edge, string(field_options[i]))
				break
			case "spawn":
				draw_text(x + edge, _oy + edge, chr(ord("A") + field_options[i]))
				break
			case "map":
				draw_text(x + edge, _oy + edge, obj_lobby.Available_maps[field_options[i]].title)
				break
		}
	}
}


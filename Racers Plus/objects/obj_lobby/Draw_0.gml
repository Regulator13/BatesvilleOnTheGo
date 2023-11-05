/// @description Draw the lobby menu



// The lobby is broken up into slots within sections
// These sections are provided by campaign units
// The default section is soldier and is where every player joins into
draw_set_font(fnt_menu)
draw_set_valign(fa_top)

#region Draw sections
var _x = section_draw_start_x
var _y = section_draw_start_y

for (var i=0; i<array_length(sections); i++){
	var section = sections[i]
	
	// Section header
	draw_set_color(c_black)
	draw_rectangle(_x, _y, _x + section_draw_width, _y + section_draw_height, false)
	draw_set_color(c_white)
	draw_rectangle(_x, _y, _x + section_draw_width, _y + section_draw_height, true)
	draw_set_halign(fa_left)
	draw_text(_x + edge, _y + edge, section.title)
		
	// Draw labels to the right of the input boxes
	draw_set_halign(fa_right)
	draw_text(color_draw_start, _y + edge, "Color ")
	
	// Header is now complete
	_y += section_draw_height
	var slot_amount = array_length(section.slots)
	for (var j=0; j<slot_amount; j++){
		var slot = section.slots[j]
		_y = draw_slot(slot, _x, _y)
		
	}
	//add one more space for the join section button
	_y += section_draw_height
}
#endregion

#region Draw minimap
if array_length(missions) > 0{
	var Map = missions[selected_mission].Map
	var draw_map_size = map_draw_size
	var draw_map_x = map_draw_start_x
	var draw_map_y = map_draw_start_y
				
	//get proper scale
	var max_dimension = Map.map_width
	if Map.map_height > max_dimension{
		max_dimension = Map.map_height
	}
	var scale = draw_map_size/max_dimension
	//draw border
	draw_set_color(c_black)
	draw_rectangle(draw_map_x, draw_map_y, draw_map_x + draw_map_size, draw_map_y + draw_map_size, false)
	//center minimap image
	var x_offset = (max_dimension - Map.map_width)*scale/2
	var y_offset = (max_dimension - Map.map_height)*scale/2
	draw_sprite_stretched(Map.sprite_index, 0, draw_map_x + x_offset, draw_map_y + y_offset, Map.map_width*scale, Map.map_height*scale)
				
	//draw details
	draw_set_color(c_white)
	draw_set_valign(fa_top)
	draw_set_halign(fa_left)
	draw_text(draw_map_x, draw_map_y + draw_map_size, Map.title)
	var details = string(Map.map_width) + "x" + string(Map.map_height)
	draw_text(draw_map_x, draw_map_y + draw_map_size + 24, details)
}
#endregion
/// @description Move slots

var _x = section_draw_start_x
var _y = section_draw_start_y

for (var i=0; i<array_length(sections); i++){
	var section = sections[i]
	
	//header is now complete
	_y += section_draw_height
	var slot_amount = array_length(section.slots)
	for (var j=0; j<slot_amount; j++){
		var slot = section.slots[j]
		_y = select_slot(slot, _x, _y)
	}
	//add one more space for the join section button
	_y += section_draw_height
}


/// @function scr_deselect_selected()
/// @description Deselects all units
//  Returns null
function scr_deselect_selected() {
	var units_selected = ds_list_size(Selected_Units)
	for (var i=0; i<units_selected; i++){
		var Unit = Selected_Units[| i]
		Unit.selected = false
		Unit.Selector = noone
	}
	ds_list_clear(Selected_Units)
}

function scr_select_unit(Unit){
	if Unit.team == team and Unit.selected = false{
		ds_list_add(Selected_Units, Unit)
		Unit.selected = true
		Unit.Selector = id
	}
}
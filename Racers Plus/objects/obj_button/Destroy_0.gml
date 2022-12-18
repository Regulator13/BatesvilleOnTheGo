/// @description Remove from Menu button list
var index = ds_list_find_index(global.Menu.Buttons, id)
if index != -1{
	ds_list_delete(global.Menu.Buttons, index)
}
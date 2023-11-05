/// @description Declare variables
Source = noone
//whether this button is selected
selected = false
//type of action to perform upon choice
action = "text"
//whether player can interact with it
active = true
//pertinent info
field = ""
//title describing box
caption = ""

//width of edge around
border = 1
//blank width inside
edge = 1

box_width = 0
box_height = 0

allow_scroll = true

ds_list_add(obj_menu.Buttons, id)

#region Functions
align = function(_x, _y){
	x = _x
	y = _y
}
get_width = function(){
	return box_width
}
get_height = function(){
	return box_height
}
#endregion
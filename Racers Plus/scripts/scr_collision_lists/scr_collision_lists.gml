/// @function                 collision_rectangle_filled_list(x1,y1,x2,y2,obj,notme,list)
/// @param {int} x1           The x coordinate of the top left of the rectangle
/// @param {int} y1           The y coordinate of the top left of the rectangle
/// @param {int} x2           The x coordinate of the bottom right of the rectangle
/// @param {int} y2           The y coordinate of the bottom right of the rectangle
/// @param {int} obj          Object to check for
/// @param {bool} notme       Whether or not to check for the calling object
/// @param {ds_list} list     The list to add items to
/// @description              Return number of a given object colliding with a given filled in rectangle and add them to a list
/// @return					  Int
function collision_rectangle_filled_list(x1,y1,x2,y2,obj,notme,list){
	count = 0
	var number = instance_number(obj)
	//Find all instances of a given objects
	for (var _i=0; _i<number; _i++){
		var Object = instance_find(obj, _i)
		//Make sure its not checking for itself unles requested
		if not notme or id != Object.id{
			//Check if they are within the bounds of the rectangle
			if Object.x >= x1 and Object.x <= x2 and Object.y >= y1 and Object.y <= y2{
				count += 1
				ds_list_add(Players, Object)
			}
		}
	}
	return count
}
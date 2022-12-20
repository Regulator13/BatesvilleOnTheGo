/// @function                 wrap_around_distance(x1, y1, x2, y2, lower_x, lower_y, upper_x, upper_y)
/// @param {int} x1           The x coordinate of the first object
/// @param {int} y1           The y coordinate of the first object
/// @param {int} x2           The x coordinate of the second object
/// @param {int} y2           The y coordinate of the second object
/// @param {int} lower_x      The lower x boundary of the room (usually 0)
/// @param {int} lower_y      The lower y boundary of the room (usually 0)
/// @param {int} upper_x      The upper x boundary of the room (usually room width)
/// @param {int} upper_y      The upper y boundary of the room (usually room height)
/// @description              Calculates the shortest distance between two objects in a wrap-around room
/// @return					  Int
function wrap_around_distance(x1, y1, x2, y2, lower_x, lower_y, upper_x, upper_y){
	var x_dist = min(abs(x1 - x2), increment_in_bounds(x1, -x2, lower_x, upper_x - 1, true), increment_in_bounds(x2, -x1, lower_x, upper_x - 1, true))
	var y_dist = min(abs(y1 - y2), increment_in_bounds(y1, -y2, lower_y, upper_y - 1, true), increment_in_bounds(y2, -y1, lower_y, upper_y - 1, true))
	return round(sqrt(power(x_dist, 2) + power(y_dist, 2)))
}
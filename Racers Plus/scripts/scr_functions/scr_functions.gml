/// @function							find_degrees_between(angle_1, angle_2)
/// @param {real} angle_1				first angle in degrees
/// @param {real} angle_2				second angle in degrees
/// @return {real} difference			difference between two angles in degrees (+ for CW, - for CCW)

function find_degrees_between(angle_1, angle_2){
	return min(abs(angle_1 - angle_2), abs(angle_1 + 360 - angle_2), abs(angle_2 - angle_1), abs(angle_2 + 360 - angle_1))
}

/// @function increment_in_bounds(variable, amount, lowerBound, upperBound, wrapAround)
/// @description Returns the value incremented within the given bounds
/// @param variable
/// @param amount
/// @param lowerBound
/// @param upperBound
/// @param wrapAround
function increment_in_bounds(argument0, argument1, argument2, argument3, argument4) {
	// Returns the value incremented within the given bounds

	// set input
	var variable = argument0;
	var amount = argument1;
	var lowerBound = argument2;
	var upperBound = argument3;
	var wrapAround = argument4;

	// increment variable
	variable += amount;

	// keep variable in bounds
	if (variable > upperBound) {
	    if (wrapAround) {
	        var extra = variable - upperBound - 1;
	        variable = lowerBound + extra;
	        }
	    else
	        variable = upperBound;
	    }
	else if (variable < lowerBound) {
	    if (wrapAround) {
	        var extra = variable - lowerBound + 1;
	        variable = upperBound + extra;
	        }
	    else
	        variable = lowerBound;
	    }

	// return result
	return variable;
}
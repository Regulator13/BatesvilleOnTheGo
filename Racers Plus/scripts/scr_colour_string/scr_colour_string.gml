/// @function scr_colour_string(from)
/// @description returns the colour index as a string
function scr_colour_string(argument0){
	// Returns string

	var col = argument0

	switch col{
		case 0:
			return "Lime"
			break;
		case 1:
			return "Red"
			break;
		case 2:
			return "Blue"
			break;
		case 3:
			return "Yellow"
			break;
		case 4:
			return "Green"
			break;
		case 5:
			return "Purple"
			break;
		case 6:
			return "Aqua"
			break;
		case 7:
			return "Maroon"
			break;
		case 8:
			return "Orange"
			break;
		case 9:
			return "Teal"
			break;
		default:
			return "Colour"
			break;
	}


}

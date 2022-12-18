/// @function scr_set_build_commands(rows, columns)
/// @description Set build commands based on amount of rows and columns
/// @returns macro index
function scr_set_build_commands(rows, columns){
	var command_macro = BUILD_1
	for (var i=0; i<rows; i++){
		for (var j=0; j<columns; j++){
			command[i, j] = command_macro
			command_macro++
		}
	}
}
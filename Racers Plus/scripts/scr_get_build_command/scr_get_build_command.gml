/// @function scr_get_build_command_row(command)
/// @description Find matching row for given comman
/// @returns macro index
function scr_get_build_command_row(command){
	for (var i=0; i<obj_buildBar.rows; i++){
		for (var j=0; j<obj_buildBar.columns; j++){
			if global.buildBar.command[i, j] == command
				return i
		}
	}
}
/// @function scr_get_build_command_col(command)
/// @description Find matching row for given comman
/// @returns macro index
function scr_get_build_command_col(command){
	for (var i=0; i<obj_buildBar.rows; i++){
		for (var j=0; j<obj_buildBar.columns; j++){
			if global.buildBar.command[i, j] == command
				return j
		}
	}
}
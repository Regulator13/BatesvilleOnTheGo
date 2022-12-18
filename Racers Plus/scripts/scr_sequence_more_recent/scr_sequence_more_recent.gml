/// @function scr_sequence_more_recent(s1, s2, max)
/// @description Returns most recent sequence account for sequence wrap around
/// @param s1 | incoming sequence
/// @param s2 | old sequence
/// @param max | max sequence till wrap around
function scr_sequence_more_recent(argument0, argument1, argument2) {
	// Returns bool

	s1 = argument0;
	s2 = argument1;
	smax = argument2;
	//start
	    {
	    return 
	        ( s1 > s2 ) and 
	        ( s1 - s2 <= smax/2 ) 
	           or
	        ( s2 > s1 ) and 
	        ( s2 - s1  > smax/2 );
	    }



}

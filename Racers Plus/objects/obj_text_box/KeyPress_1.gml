/// @description Process text box
if (selected){
	text = keyboard_string
	
	// Keep text in bounds
	if max_characters != -1 and string_length(text) > max_characters{
		text = string_copy(text, 0, max_characters)
		keyboard_string = text
	}
}

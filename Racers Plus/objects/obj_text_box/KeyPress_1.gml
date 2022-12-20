/// @description Process text box
if selected{
	text = keyboard_string
	if max_text_length != -1 and string_length(text) > max_text_length{
		text = string_copy(text, 0, max_text_length)
		keyboard_string = text
	}
	if action == "client-send-name"{
		event_user(0)
	}
}

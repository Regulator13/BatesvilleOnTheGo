/// @description Initialize text box

event_inherited()

text = "Enter input here"
// Store previous text in case input was invalid
// Action function must restore to previous_text if input is invalid
previous_text = ""

caption = "Text Box"

h_align = fa_left
v_align = fa_top

//restrictions
max_characters = -1
max_text_width = 0
draw_set_font(fnt_menu)
max_text_height = string_height("a")

//time between blinks in steps
draw_cursor = false
blink_timer = 30

#region Functions
select = function(){
	previous_text = text
	keyboard_string = text
	selected = true
	draw_cursor = true
	alarm[0] = blink_timer
	allow_scroll = false
	obj_menu.continue_input_checking = false
}
deselect = function(){
	selected = false
	draw_cursor = false
	allow_scroll = true
}
get_width = function(){
	return border*2 + max_text_width
}
get_height = function(){
	return border*2 + max_text_height
}	
#endregion
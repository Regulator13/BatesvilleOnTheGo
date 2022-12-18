/// @description Initialize text box

event_inherited()

text = "Enter input here"
caption = "Text Box"

h_align = fa_left
v_align = fa_top

//restrictions
max_text_length = -1
max_text_width = 0
draw_set_font(fnt_basic_small)
max_text_height = string_height("a")

//time between blinks in steps
draw_cursor = false
blink_timer = 10
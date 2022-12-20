/// @description Click button
if point_in_rectangle(mouse_x, mouse_y, x, y, x + box_width, y + box_height){
	audio_play_sound(snd_mouseclick, 1, 0)
	global.Menu.continue_input_checking = false
	event_user(0)
}
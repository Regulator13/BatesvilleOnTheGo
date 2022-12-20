/// @description Run tests

//set new speed at the beginning of every sample
if sample_counter == 0{
	game_set_speed(test_speeds[test], gamespeed_fps)
	turn_start = get_timer()
}
sample_counter++

if sample_counter == samples{
	turn_actual_speed = get_timer() - turn_start
	//check if this is the new min
	var millipf = turn_actual_speed/samples/1000
	if millipf < min_millipf min_millipf = millipf
	scr_log_turn_speed(obj_client.client_speed_log, samples, game_get_speed(gamespeed_microseconds), turn_actual_speed, fps_real)
	sample_counter = 0
	test++
	if test == speeds{
		scr_log(obj_client.client_speed_log, "--End of Performance Test--")
		//test is complete
		show_debug_message("Performance test is complete")
		scr_client_send_performance(min_millipf*1000)
		instance_destroy()
	}
}
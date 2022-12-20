/// @description Setup test
//this objects job is to test the client's performance ability to gauge its maximum fps

//doing 20 samples is about as effective as doing 100
samples = 20
sample_counter = 0

speeds = 10
test_speeds = array_create(speeds)
for (var i=0; i<speeds; i++){
	test_speeds[i] = 100 - 10*i
}
//start at first test
test = 0

turn_start = 0
turn_actual_speed = 0

min_millipf = 100
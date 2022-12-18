/// @description Post-initialization setup
if room != mnu_main and room != mnu_lobby and room != mnu_score{
	//get unique player colour based on join order
	show_debug_message("obj_player connect_id: " + string(connect_id) + scr_colour_string(connect_id))
	
	/// @description Create Car
	Car = instance_create_layer(global.player_start[0], global.player_start[1], "lay_instances", obj_car)

	Car.turn_speed = model_turn_speeds[model]
	Car.accel = model_accels[model]
	Car.brake = model_brakes[model]
	Car.nitrus_max = model_nitrus_maxes[model]
	Car.max_gear = model_max_gears[model]
	Car.gear_max_speed = model_gear_max_speeds[model]
	Car.gear_min_speed = model_gear_min_speeds[model]
	Car.shift_period = model_shift_periods[model]
	Car.traction = model_tractions[model]
	Car.hp_max = model_hp_maxes[model]
	Car.nitrus = Car.nitrus_max
	Car.max_speed = Car.gear_max_speed[Car.max_gear]
	Car.hp = Car.hp_max
	Car.weight = model_weights[model]
	Car.sprite_index = vehicle_sprites[model]
	Car.Player = self
	Car.model = model
}
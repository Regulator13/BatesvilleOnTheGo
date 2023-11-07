/// @description Create Car

var Business = global.businesses[? Parent.team]

////TODO global.player_start
////TODO Prevent overlap
sprite_index = vehicle_sprites[model]
image_angle = 90
var x_offset = 0
while not place_empty(Business.x - x_offset, Business.y + Business.sprite_height + 32){
	x_offset += 16
}

Car = instance_create_layer(Business.x - x_offset, Business.y + Business.sprite_height + 32, "lay_instances", obj_car)

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
Car.image_blend = obj_menu.color_array[Parent.player_color]
Car.car_dir = 0
Car.image_angle = -90

/// @function scr_perform_input(input, input_x, input_y)
/// @description Perform input outside of step for better ordering
/// @param input | input identifier
/// @param input_x | x position for input when applicable
/// @param input_y | y position for input when applicable
//  Returns null
function	(input, input_x, input_y){
	//Set queue input variables as temporary

	//all input is performed from obj_player's perspective
	//switch statement for all non-range input
	#region Non-range command
	//Localize variables
	var grid_width = obj_map_generator.width
	var grid_height = obj_map_generator.height
	var grid = obj_map_generator.grid
	//Find current terrain height
	var current_terrain = grid[# Character.x div GRID_SIZE, Character.y div GRID_SIZE]
	//Set energy cost of movement
	var energy_required = COST_BASE
	var max_energy_lost = COST_MAX_BASE
	switch(input){
		#region Movement
		case MOVE_LEFT:
			if Character.move_timer == 0{
				//If the terrain height being traveled then is at most 1 greater than the current height
				var destination_terrain = grid[# increment_in_bounds(Character.x div GRID_SIZE, -1, 0, grid_width - 1, true), Character.y div GRID_SIZE]
				if destination_terrain <= current_terrain + 1 and destination_terrain > TOP_WATER_LEVEL{
					if destination_terrain == current_terrain + 1 and destination_terrain > TOP_GRASS_LEVEL{
						energy_required += COST_MOUNTAIN_CLIMB
						max_energy_lost += COST_MAX_MOUNTAIN_CLIMB
					}
					else if destination_terrain == current_terrain + 1{
						energy_required += COST_GRASS_CLIMB
						max_energy_lost += COST_MAX_GRASS_CLIMB
					}
					if Character.energy >= energy_required{
						with Character{
							var x_destination = x
							//Check for wrap around
							if x < GRID_SIZE{
								x_destination += grid_width*GRID_SIZE
							}
							x_destination -= GRID_SIZE
							//Make sure destination is open
							if place_free(x_destination, y){
								direction = 180
								speed = 1
								move_timer = move_speed
								energy -= energy_required
								max_energy -= max_energy_lost
							}
						}
					}
				}
			}
			break
		case MOVE_UP:
			if Character.move_timer == 0{
				var destination_terrain = grid[# Character.x div GRID_SIZE, increment_in_bounds(Character.y div GRID_SIZE, -1, 0, grid_height - 1, true)]
				if destination_terrain <= current_terrain + 1 and destination_terrain > TOP_WATER_LEVEL{
					if destination_terrain == current_terrain + 1 and destination_terrain > TOP_GRASS_LEVEL{
						energy_required += COST_MOUNTAIN_CLIMB
						max_energy_lost += COST_MAX_MOUNTAIN_CLIMB
					}
					else if destination_terrain == current_terrain + 1{
						energy_required += COST_GRASS_CLIMB
						max_energy_lost += COST_MAX_GRASS_CLIMB
					}
					if Character.energy >= energy_required{
						with Character{
							var y_destination = y
							//Check for wrap around
							if y < GRID_SIZE{
								y_destination += grid_height*GRID_SIZE
							}
							y_destination -= GRID_SIZE
							//Make sure destination is open
							if place_free(x, y_destination){
								direction = 90
								speed = 1
								move_timer = move_speed
								energy -= energy_required
								max_energy -= max_energy_lost
							}
						}
					}
				}
			}
			break
		case MOVE_RIGHT:
			if Character.move_timer == 0{
				var destination_terrain = grid[# increment_in_bounds(Character.x div GRID_SIZE, 1, 0, grid_width - 1, true), Character.y div GRID_SIZE]
				if destination_terrain <= current_terrain + 1 and destination_terrain > TOP_WATER_LEVEL{
					if destination_terrain == current_terrain + 1 and destination_terrain > TOP_GRASS_LEVEL{
						energy_required += COST_MOUNTAIN_CLIMB
						max_energy_lost += COST_MAX_MOUNTAIN_CLIMB
					}
					else if destination_terrain == current_terrain + 1{
						energy_required += COST_GRASS_CLIMB
						max_energy_lost += COST_MAX_GRASS_CLIMB
					}
					if Character.energy >= energy_required{
						with Character{
							var x_destination = x
							//Check for wrap around
							if x >= grid_width*GRID_SIZE - GRID_SIZE{
								x_destination -= grid_width*GRID_SIZE
							}
							x_destination += GRID_SIZE
							//Make sure destination is open
							if place_free(x_destination, y){
								direction = 0
								speed = 1
								move_timer = move_speed
								energy -= energy_required
								max_energy -= max_energy_lost
							}
						}
					}
				}
			}
			break
		case MOVE_DOWN:
			if Character.move_timer == 0{
				var destination_terrain = grid[# Character.x div GRID_SIZE, increment_in_bounds(Character.y div GRID_SIZE, 1, 0, grid_height - 1, true)]
				if destination_terrain <= current_terrain + 1 and destination_terrain > TOP_WATER_LEVEL{
					if destination_terrain == current_terrain + 1 and destination_terrain > TOP_GRASS_LEVEL{
						energy_required += COST_MOUNTAIN_CLIMB
						max_energy_lost += COST_MAX_MOUNTAIN_CLIMB
					}
					else if destination_terrain == current_terrain + 1{
						energy_required += COST_GRASS_CLIMB
						max_energy_lost += COST_MAX_GRASS_CLIMB
					}
					if Character.energy >= energy_required{
						with Character{
							var y_destination = y
							//Check for wrap around
							if y >= grid_height*GRID_SIZE - GRID_SIZE{
								y_destination -= grid_height*GRID_SIZE
							}
							y_destination += GRID_SIZE
							//Make sure destination is open
							if place_free(x, y_destination){
								direction =270
								speed = 1
								move_timer = move_speed
								energy -= energy_required
								max_energy -= max_energy_lost
							}
						}
					}
				}
			}
			break
		#endregion
		case ACTION:
			//If there is food in the current square, eat it
			var Inst = instance_position(Character.x + (GRID_SIZE div 2), Character.y + (GRID_SIZE div 2), par_food)
			if Inst != noone{
				Character.max_energy += Inst.food_value
				instance_destroy(Inst)
				break
			}
			//If there is an animal in the current square, attack it
			Inst = instance_position(Character.x + (GRID_SIZE div 2), Character.y + (GRID_SIZE div 2), par_animal)
			if Inst != noone{
				if Character.energy >= COST_ATTACK{
					Inst.hp -= Character.attack
					Character.energy -= COST_ATTACK
				}
			}
			//If there is nothing in the current square, try to shout
			else{
				if Character.energy >= COST_SHOUTING{
					if obj_map_generator.grid[# Character.x/GRID_SIZE, Character.y/GRID_SIZE] < MAX_HEIGHT{
						obj_map_generator.grid[# Character.x/GRID_SIZE, Character.y/GRID_SIZE]++
					}
					/*
					with instance_create_layer(Character.x, Character.y, LAY, obj_sound_origin){
						volume = 10
						max_size = 512
						circle_color = c_orange
					}
					*/
					Character.max_energy -= COST_SHOUTING
				}
			}
			break
	}
	#endregion
	show_debug_message(string(obj_map_generator.grid[# Character.x div GRID_SIZE, Character.y div GRID_SIZE]))
}

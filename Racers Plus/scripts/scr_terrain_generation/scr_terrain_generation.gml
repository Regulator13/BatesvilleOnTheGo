/// @function                 diamond_step(grid, iteration);
/// @param {ds_grid} grid     The grid of the terrain heights on the map
/// @param {int} iteration    The number of times this function has been called before
/// @description              Finds the average value of the terrain for all squares and assigns it to the center (with random variance)
function diamond_step(grid, iteration){
	//Find the size of each square
	square_size = (size - 1) div (power(2, iteration))

	//Find the number of rows and columns of squares
	rows = power(2, iteration)

	//Calculate the midpoint of each square to be the average of the corners plus a random value
	for (i=0; i<rows; i++){
		//Row number and column number are the same because square
		for (j=0; j<rows; j++){
			//Find the square vertex values
			top_left = ds_grid_get(grid, i*square_size, j*square_size)
			top_right = ds_grid_get(grid, (i+1)*square_size, j*square_size)
			bot_left = ds_grid_get(grid, i*square_size, (j+1)*square_size)
			bot_right = ds_grid_get(grid, (i+1)*square_size, (j+1)*square_size)

			//Find the average and assign it to the midpoint plus a random value
			ds_grid_set(grid,floor((i*square_size) + ((i+1)*square_size))/2, floor((j*square_size) + ((j+1)*square_size))/2, min(max(round((top_left + top_right + bot_left + bot_right + irandom_range(-max(RAND_WEIGHT - iteration, 0), max(RAND_WEIGHT - iteration, 0)))/4), MIN_HEIGHT), MAX_HEIGHT))
		}
	}
	//return the grid
	return grid
}



/// @function                 square_step(grid, iteration);
/// @param {ds_grid}  grid    The grid of the terrain heights on the map
/// @param {int}  iteration   The number of times this function has been called before
/// @description              Finds the average value of the terrain for all diamonds and assigns it to the center (with random variance)
function square_step(grid, iteration){
	//Find the size of each diamond
	diamond_size = (size - 1) div power(2, iteration)

	//Find the number of rows and columns of squares
	rows = power(2, (iteration + 1)) + 1

	//Calculate the midpoint of each diamond to be the average of the corners plus a random value
	for (i=0; i<rows; i++){
		//The number of diamonds in each row changes. Rows alternate between 2^iteration diamonds and 2^iteration + 1 diamonds
		if i % 2 == 0{
			cols = power(2, iteration)
		}
		else{
			cols = power(2, iteration) + 1
		}
		for (j=0; j<cols; j++){
			//For even rows, grid[row][col] is the left vertex
			if i % 2 == 0{
				left = ds_grid_get(grid, (i div 2)*diamond_size, j*diamond_size)
				right = ds_grid_get(grid, (i div 2)*diamond_size, (j+1)*diamond_size)
				//If the top wraps around, an extra 1 must be subtracted to account for offset in array
				//No wrap
				if (i div 2)*diamond_size - (diamond_size div 2) >= 0{
					top = ds_grid_get(grid, (i div 2)*diamond_size - (diamond_size div 2), j*diamond_size + (diamond_size div 2))
				}
				//Wrap
				else{
					top = ds_grid_get(grid, (size - 1) - (diamond_size div 2), j*diamond_size + (diamond_size div 2))
				}
				//If the bottom wraps around, start counting from top
				//No wrap
				if (i div 2)*diamond_size + (diamond_size div 2) <= (size - 1){
					bottom = ds_grid_get(grid, (i div 2)*diamond_size + (diamond_size div 2), j*diamond_size + (diamond_size div 2))
				}
				//Wrap
				else{
					bottom = ds_grid_get(grid, diamond_size div 2, j*diamond_size + (diamond_size div 2))
				}
				//Find the average and assign it to the midpoint plus a random value
				ds_grid_set(grid, i*diamond_size div 2, j*diamond_size + (diamond_size div 2), min(max(round((top + left + right + bottom + irandom_range(-max(RAND_WEIGHT - iteration, 0), max(RAND_WEIGHT - iteration, 0)))/4), MIN_HEIGHT), MAX_HEIGHT))
			}
			//For odd rows, grid[row][col] is the center
			else{
				top = ds_grid_get(grid, ((i-1) div 2)*diamond_size, j*diamond_size)
				bottom = ds_grid_get(grid, ((i+1) div 2)*diamond_size, j*diamond_size)

				//If the left wraps around, an extra 1 must be subtracted to account for offset in array
				//No wrap
				if (j*diamond_size - (diamond_size div 2)) >= 0{
					left = ds_grid_get(grid, (i*diamond_size div 2), j*diamond_size - (diamond_size div 2))
				}
				//Wrap
				else{
					left = ds_grid_get(grid, (i*diamond_size div 2), (size - 1) - (diamond_size div 2))
				}
				//If the right wraps around, start counting from left
				//No wrap
				if (j*diamond_size + (diamond_size div 2)) <= (size - 1){
					right = ds_grid_get(grid, (i*diamond_size div 2), j*diamond_size + (diamond_size div 2))
				}
				//Wrap
				else{
					right = ds_grid_get(grid, i*diamond_size div 2, diamond_size div 2)
				}

				//Find the average and assign it to the midpoint plus a random value
				ds_grid_set(grid, i*diamond_size div 2, j*diamond_size, min(max(round((top + left + right + bottom + irandom_range(-max(RAND_WEIGHT - iteration, 0), max(RAND_WEIGHT - iteration, 0)))/4), MIN_HEIGHT), MAX_HEIGHT))
			}
		}
	}
	return grid
}

/// @description Hit a cone

//If the cone is up
if not other.flattened{
	if speed >= 0{
		speed -= 8/weight
		if speed < 0 speed = 0
	}
	else{
		speed += 8/weight
		if speed > 0 speed = 0
	}
	hp -= 4
	other.alarm[0] = other.reset_delay
	other.flattened = true
	other.image_index = 1
}
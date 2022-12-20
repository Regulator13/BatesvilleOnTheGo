function scr_ds_list_average(list){
	var total = 0
	var count = ds_list_size(list)
	for (var i=0; i<count; i++){
		total += list[| i]
	}
	return total/count
}

function scr_ds_list_maximum(list){
	var max_value = 0
	var count = ds_list_size(list)
	for (var i=0; i<count; i++){
		if list[| i] > max_value{
			max_value = list[| i]
		}
	}
	return max_value
}
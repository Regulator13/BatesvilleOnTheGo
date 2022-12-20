/// @description Set home based on customer_ids
if customer_id != 0{
	for (var i=0; i<instance_number(obj_structure); i++){
		var Structure = instance_find(obj_structure, i)
		if Structure.customer_id == customer_id{
			Home = Structure
		}
	}
}
else{
	// Find nearest structure
	var Structure = instance_nearest(x, y, obj_structure)
	if Structure.customer_id == customer_id{
			Home = Structure
	}
}


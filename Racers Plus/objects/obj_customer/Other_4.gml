/// @description Set home based on customer_ids
for (var i=0; i<instance_number(obj_structure); i++){
	var Structure = instance_find(obj_structure, i)
	if Structure.customer_id == customer_id{
		Home = Structure
	}
}



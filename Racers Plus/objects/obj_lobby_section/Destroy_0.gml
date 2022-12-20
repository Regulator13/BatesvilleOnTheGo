/// @description Clean up data structures
ds_list_destroy(Players)
instance_destroy(Join_box)
if instance_exists(Team_box){
	instance_destroy(Team_box)
	instance_destroy(Color_box)
}

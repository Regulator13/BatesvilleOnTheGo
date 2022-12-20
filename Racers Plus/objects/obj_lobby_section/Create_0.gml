/// @description Holder for spawn variables
/*This object is in charge of temporarily holding all the information for a section in the lobby
* It will be created whenever a chosen map has a spawn a previous map did not
* It will be destroyed whenever a chosen map does not have this spawn, returning all players
* to the default section
*/

//list of all the players assigned to this spawn
Players = ds_list_create()
team = 0
//index in the global color array
spawn_color = 0
spawn_x = -1
spawn_y = -1

section_type = -1

Join_box = noone
//if section is for a spawn create input boxes
Team_box = noone
Color_box = noone

//set in obj_client when starting to identify spawn
index = -1
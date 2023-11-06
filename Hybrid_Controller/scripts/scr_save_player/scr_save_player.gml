/// @function scr_save_player()
/// @description Saves the player data to a file
//  Returns null
function scr_save_player(name, direct_ip) {
	//open file
	ini_open("player.ini")
    
	//save data
	var section = "online"
	ini_section_delete(section)
	ini_write_string(section, "name", name)	
	ini_write_string(section, "direct_ip", direct_ip)
    
	//close file
	ini_close()
}

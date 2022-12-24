/// @function scr_load_player()
/// @description Loads the player data
function scr_load_player() {
	// Returns null

	// open file
	if (file_exists("player.ini")) {
	    ini_open("player.ini");
    
	    // load name
	    var section = "online";
		if os_browser == browser_not_a_browser{
		    Name_input.text = ini_read_string(section, "name", "Newbius");
			Direct_IP.text = ini_read_string(section, "direct_ip", "192.168.137.1");
		}
		else{
			default_name = ini_read_string(section, "name", "Newbius");
			default_ip = ini_read_string(section, "direct_ip", "192.168.137.1");
		}
    
	    //close file
	    ini_close();
	    }



}

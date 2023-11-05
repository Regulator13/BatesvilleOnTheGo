/// @description Action, select without mouse
if active{
	if not selected{
		select()
	}
	else{
		// Perform action
		// Action function must restore to previous_text if input is invalid
		action(self)
		deselect()
	}
}

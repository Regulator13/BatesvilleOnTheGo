/// @description Action
if action == VALUEACTION_BUTTON {
	value_action(self)
}
else if action == VALUE_BUTTON {
	// Pass
}
else {
	action(self)
}
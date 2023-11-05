/// @description Declare instance variables

event_inherited()

image_speed = 0
// What button does when pressed
action = "quit"
title = "Default"

// Value buttons are scroll bars allowing selection of different states
values = ds_list_create()
// Current value (index of values)
value = 0
// Some value buttons can perform an action when switching states
value_action = ""
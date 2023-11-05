/// @description Set variables
controller = {}
control = -1
Source = noone //button who created this, used for title chaning

// reset input
io_clear()

axis_controls = [gp_axislh, gp_axislv, -gp_axislh, -gp_axislv, gp_axisrh, gp_axisrv, -gp_axisrh, -gp_axisrv]
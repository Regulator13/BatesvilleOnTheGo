/// @description Update for current loyality

// alarm[0] will be -1 if customer is inactive
if alarm[0] != -1{
	Home.image_alpha = loyality
	Home.image_blend = global.business_colors[loyal_team]
}
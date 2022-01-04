/// @description Draw Vehicle

image_angle = car_dir - 90
draw_self()
var w = 16
var h = 20
draw_healthbar(x - w, y + 32, x + w, y + 32 + h, (hp/hp_max)*100, c_black, c_red, c_green, 0, false, true)
draw_healthbar(x - w, y + 32 + 5 + h, x + w, y + 32 + 5 + 2*h, (nitrus/nitrus_max)*100,  c_black, c_red, c_blue, 0, false, true)
draw_set_font(fnt_text)
draw_set_color(c_white)
draw_set_halign(fa_middle)
draw_text(x, y + 32, "Gear: " + string(gear))

//TODO - Replace with proper HUD
for (var i=0; i<ds_list_size(picked_up_deliveries); i++){
	draw_text(32, 32 + 32*i, string(picked_up_deliveries[| i]))
}

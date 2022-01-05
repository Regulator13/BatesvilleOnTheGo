/// @description Draw Vehicle

image_angle = car_dir - 90
draw_self()
var w = 16
var h = 10
draw_healthbar(x - w, y + 32, x + w, y + 32 + h, (hp/hp_max)*100, c_black, c_red, c_green, 0, false, true)
draw_healthbar(x - w, y + 32 + 5 + h, x + w, y + 32 + 5 + 2*h, (nitrus/nitrus_max)*100,  c_black, c_red, c_blue, 0, false, true)
draw_set_font(fnt_text)
draw_set_color(c_white)
draw_set_halign(fa_middle)
draw_set_valign(fa_top)
draw_text(x, y + 32, "Gear: " + string(gear))

//TODO - Replace with proper HUD
for (var i=0; i<ds_list_size(picked_up_deliveries); i++){
	draw_set_color(global.business_colors[get_business_id(picked_up_deliveries[| i])])
	draw_rectangle(100*Player.controls, 32 + 16*i, 100*Player.controls + 32, 48 + 16*(i), false)
	draw_set_color(c_white)
	draw_text(100*Player.controls + 8, 32 + 16*i, string(get_order_number(picked_up_deliveries[| i])))
}

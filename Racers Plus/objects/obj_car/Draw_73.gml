/// @description Draw HUD

var w = 16
var h = 10
var by = 24
draw_healthbar(x - w, y + by, x + w, y + by + h, (hp/hp_max)*100, c_black, c_red, c_green, 0, false, true)
draw_healthbar(x - w, y + by + 5 + h, x + w, y + by + 5 + 2*h, (nitrus/nitrus_max)*100,  c_black, c_red, c_blue, 0, false, true)
draw_set_font(fnt_text)
draw_set_color(c_white)
draw_set_halign(fa_middle)
draw_set_valign(fa_top)
draw_text(x, y - 32, "Gear: " + string(gear))
//draw_text(x, y - 64, "Steer: " + string(steer))
draw_text(x, y - 64, "Align: " + string(align_buffer))

//TODO - Replace with proper HUD
for (var i=0; i<ds_list_size(picked_up_deliveries); i++){
	draw_set_color(global.business_colors[get_business_id(picked_up_deliveries[| i])])
	draw_rectangle(100*controls, 32 + 16*i, 100*controls + 32, 48 + 16*(i), false)
	draw_set_color(c_white)
	draw_text(100*controls + 8, 32 + 16*i, string(get_order_number(picked_up_deliveries[| i])))
}

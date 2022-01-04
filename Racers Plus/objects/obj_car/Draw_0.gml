/// @description Draw Vehicle

image_angle = car_dir - 90
draw_self()
draw_healthbar(x - 100, y + 100, x + 100, y + 120, (hp/hp_max)*100, c_black, c_red, c_green, 0, false, true)
draw_healthbar(x - 100, y + 125, x + 100, y + 145, (nitrus/nitrus_max)*100,  c_black, c_red, c_blue, 0, false, true)
draw_set_font(ft_text)
draw_set_color(c_black)
draw_text(x - 100, y + 150, "Gear: " + string(gear))
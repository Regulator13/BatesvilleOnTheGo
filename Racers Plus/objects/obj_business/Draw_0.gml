/// @description Draw score
draw_self()
draw_set_halign(fa_middle)
draw_set_valign(fa_center)
draw_set_color(c_white)
//draw_text(x + sprite_width/2, y + sprite_height/2, string(popularity))
draw_text(x + sprite_width/2, y + sprite_height/2, string(obj_campaign.Teams[? business_id].team_score))
// Used only in the score menu
ready_to_start = false
player_name = ""
player_color = 0
team = 1

connect_id = -1  //order in which client connected to server, not an index to any list

#region Campaign
// Group player is currently a part of
Group = noone
#endregion

Parent = noone

Player = instance_create_layer(x, y, "lay_instances", obj_player)
Player.Parent = self
(* utility functions *)
open Game_data

let update_invulnerability delta collision player =
  let invulnerability = if collision && player.invulnerability = 0.
    then player_invulnerability_time else
  max (player.invulnerability -. delta) 0. in
  {player with invulnerability}

let update_state delta textures (player, env_items, c, m) =
  (* *)
  let input = Io.read_input () in
  let (player, env_items, c, m), _ =
    if input.restart then World.init (c, textures)
    else ((player, env_items, c, m), textures) in
  let input_vector = if player.damage < player_max_damage then
             input.vector else Raylib.Vector2.create 0. 0. in
  let player, env_items, collision = Physics.check_collisions player env_items false in
  let player = player |>
    Physics.update_player_velocity input_vector collision |>
    Physics.update_player_position delta env_items collision |>
    update_invulnerability delta collision in
   (player, env_items, c, m)


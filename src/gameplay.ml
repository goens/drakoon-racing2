(* utility functions *)
open Game_data

let update_invulnerability delta collision player =
  let invulnerability = if collision && player.invulnerability = 0.
    then player_invulnerability_time else
  max (player.invulnerability -. delta) 0. in
  {player with invulnerability}

let update_player delta (player, env_items, c, m) =
  (* *)
  let input_vector = if player.damage < player_max_damage
                     then Io.read_input () else Raylib.Vector2.create 0. 0. in
  let player, env_items, collision = Physics.check_collisions player env_items false in
  let player = player |>
    Physics.update_player_velocity input_vector collision |>
    Physics.update_player_position delta env_items collision |>
    update_invulnerability delta collision in
   (player, env_items, c, m)


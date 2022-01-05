(* utility functions *)
let update_player delta (player, env_items, c, m) =
  let input_vector = Io.read_input () in
  let player = player |> Physics.update_player_velocity input_vector |> Physics.update_player_position delta env_items
  in (player, env_items, c, m)

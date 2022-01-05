(* Physics *)
open Game_data

let update_player_velocity input_vector player =
let open Raylib.Vector2 in
  let vel : t = player.velocity in
  let vel_new = add vel (scale input_vector player_acceleration) in
  let speed = length vel_new in
  let factor = if speed <= player_max_speed
     then 1.
     else player_max_speed /. speed in
  {player with velocity = scale vel_new factor}

let update_player_position delta _ player =
let open Raylib.Vector2 in
  let vel : t = player.velocity in
  let pos : t = player.position in
  (* does not account for collisions yet*)
  let position = add pos (scale vel delta) in
  {player with position = position}
